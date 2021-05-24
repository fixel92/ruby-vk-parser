class Comment < Type
  attr_reader :id, :group_id, :post, :vk

  MESSAGE_TYPE = { post_comments: 'Комментарий', topic_comments: 'Запись в обсуждении' }.freeze

  def self.get_valid(group_id, post, type, data)
    comments_post = new(group_id: group_id, post: post, data: data)
    comments_post.check(type)
  end

  def initialize(params = {})
    super
    @group_id = params[:group_id]
    @post = params[:post]
    @db = Database.new
    @keywords = params[:data][:keywords]
    @anti_keywords = params[:data][:anti_keywords]
  end

  # get comments post or topic
  def objects(type)
    sleep(REQUESTS_INTERVAL)
    if type == :post_comments
      @vk.wall.get_comments(access_token: token,
                            owner_id: -@group_id,
                            post_id: @post.id,
                            sort: 'desc',
                            count: 99)['items']
    elsif type == :topic_comments
      @vk.board.get_comments(access_token: token,
                             group_id: @group_id,
                             topic_id: @post.id,
                             sort: 'desc',
                             count: 99)['items']
    end
  end

  def reply_comment(comment)
    if comment['reply_to_comment'].nil?
      ''
    else
      "-&thred=#{comment['reply_to_comment']}"
    end
  end

  # url comment
  def slug(type, comment)
    case type
    when :post_comments
      "https://vk.com/wall#{-@group_id}_#{@post.id}" \
      "?reply=#{comment.id}+#{reply_comment(comment)}" \
      "&w=wall#{-@group_id}_#{@post.id}_r#{comment.id}"
    when :topic_comments
      "https://vk.com/topic#{-@group_id}_#{@post.id}" \
      "?post=#{comment.id} -"
    end
  end

  def message(type, comment)
    {
      type: MESSAGE_TYPE[type],
      url: slug(type, comment),
      text: comment.text,
      image: post_image(post),
      date: Time.at(comment.date).strftime("%d/%m/%Y"),
      keywords: check_keyword(@keywords, comment.text)
    }
  end

  # check keywords and record db
  def check(type)
    messages = []
    objects(type).each do |comment|
      next unless text_fits?(@keywords, @anti_keywords, comment.text) & check_date(comment.date)

      next if @db.in_db?(type, slug(type, comment))

      @db.write_to_db(type, slug: slug(type, comment))
      messages << message(type, comment)
    end
    @db.close
    messages - []
  end

  private

  def post_image(post)
    if post.attachments
      post.attachments.first.photo&.photo_130
    end
  end
end
