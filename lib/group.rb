require 'vkontakte_api'
require_relative '../config'

VK = VkontakteApi::Client.new(@service_token)

class Group
  def self.get_groups_id(urls)
    group_names = []
    urls.each do |url|
      group_names << url.split('/').last
    end
    VK.groups.getById(group_ids: group_names)
  end

  def initialize(id)
    @group_id = id
    @group_ids = []
  end

  def get_posts(count_posts)
    posts = VK.wall.get(owner_id: "-#{@group_id}", count: count_posts)['items']
    if posts.empty?
      puts "Не получены посты группы #{@group_id}"
    else
      posts
    end
  end

  def get_topics
    #todo
  end

  def get_post_comments
    #todo
  end

  def get_topic_comments
    #todo
  end
end
