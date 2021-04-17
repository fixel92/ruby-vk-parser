class Post < Type
  attr_reader :id, :group_id, :vk

  MESSAGE_TYPE = 'Запись на стене'.freeze

  def self.get_valid(group_id, data)
    messages = []
    new_post = new(group_id: group_id, data: data)
    posts = new_post.objects(post_count: 20) # get posts
    if posts.empty?
      messages << Group.message_none_posts(group_id)
    else
      # check posts and send in messages
      new_post.check(posts).each { |item| messages << item }
      posts.each do |post|
        Comment.get_valid(group_id, post, :post_comments, data).each { |item| messages << item }
      end
    end

    messages
  end

  def initialize(params = {})
    super
    @group_id = params[:group_id]
    @db = Database.new
    @keywords = params[:data][:keywords]
    @anti_keywords = params[:data][:anti_keywords]
  end

  # get posts
  def objects(params = {})
    sleep(1)
    begin
      return @vk.wall.get(owner_id: "-#{@group_id}", count: params[:post_count])['items']
    rescue VkontakteApi::Error => e
      puts e
      return []
    end
  end

  def slug(post)
    "https://vk.com/wall#{-@group_id}_#{post['id']}"
  end

  def message(post)
    {
      type: MESSAGE_TYPE,
      url: slug(post),
      text: post.text,
      date: Time.at(post.date).strftime("%d/%m/%Y"),
      keywords: check_keyword(@keywords, post.text)
    }
  end

  def check(posts)
    messages = []
    posts.each do |post|
      next unless text_fits?(@keywords, @anti_keywords, post.text) & check_date(post.date)

      next if @db.in_db?('posts', slug(post))

      @db.write_to_db('posts', slug: slug(post))
      messages << message(post)
    end
    @db.close
    messages - []
  end
end
