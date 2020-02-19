class Comment < Type
  attr_reader :id, :group_id, :post, :vk

  def self.get_valid(group_id, post, type)
    comments_post = new(group_id: group_id, post: post)
    comments_post.check(type)
  end

  def initialize(params = {})
    super
    @group_id = params[:group_id]
    @post = params[:post]
    @db = Database.new
  end

  # get comments post or topic
  def objects(type)
    sleep(1)
    if type == 'post_comments'
      @vk.wall.get_comments(access_token: token,
                            owner_id: -@group_id,
                            post_id: @post.id,
                            sort: 'desc',
                            count: 99)['items']
    elsif type == 'topic_comments'
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
    if type == 'post_comments'
      "https://vk.com/wall#{-@group_id}_#{@post.id}" \
      "?reply=#{comment.id}+#{reply_comment(comment)}" \
        "&w=wall#{-@group_id}_#{@post.id}_r#{comment.id}"
    elsif type == 'topic_comments'
      "https://vk.com/topic#{-@group_id}_#{@post.id}" \
      "?post=#{comment.id} -"
    end
  end

  def message_post(comment)
    "Комментарий https://vk.com/wall#{-@group_id}_#{@post.id}" \
    "?reply=#{comment.id}+#{reply_comment(comment)}" \
    "&w=wall#{-@group_id}_#{@post.id}_r#{comment.id} -" +
      check_keyword(keywords, comment['text']).to_s
  end

  def message_topic(comment)
    "Запись в обсуждении https://vk.com/topic#{-@group_id}_#{@post.id}" \
    "?post=#{comment.id} -" +
      check_keyword(keywords, comment['text']).to_s
  end

  # check keywords and record db
  def check(type)
    messages = []
    objects(type).each do |comment|
      next unless text_fits?(keywords, anti_keywords, comment['text']) & check_date(comment.date)

      next if @db.in_db?(type, slug(type, comment))

      @db.write_to_db(type, slug: slug(type, comment))
      messages << message_post(comment) if type == 'post_comments'
      messages << message_topic(comment) if type == 'topic_comments'
    end
    @db.close
    messages - []
  end
end

