require 'vkontakte_api'
require_relative 'type'
require_relative 'database'

class Post < Type
  attr_reader :id, :group_id, :vk

  def initialize(params = {})
    super
    @group_id = params[:group_id]
    @db = Database.new
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

  def message(post)
    "Запись на стене https://vk.com/wall#{-@group_id}_#{post['id']} -" +
      check_keyword(KEYWORDS, post['text']).to_s
  end

  def slug(post)
    "https://vk.com/wall#{-@group_id}_#{post['id']}"
  end

  def check(posts)
    messages = []
    posts.each do |post|
      next unless text_fits?(KEYWORDS, ANTI_KEYWORDS, post['text'])

      next if @db.in_db?('posts', slug(post))

      @db.write_to_db('posts', slug: slug(post))
      messages << message(post)
    end
    @db.close
    messages - []
  end
end
