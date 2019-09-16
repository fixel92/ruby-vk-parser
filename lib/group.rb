require 'vkontakte_api'
require_relative '../config'
require 'pry'

VK = VkontakteApi::Client.new(@service_token)

TOKEN = @service_token

class Group
  attr_reader :group_id

  def self.get_group_ids(urls)
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
    VK.wall.get(owner_id: "-#{@group_id}", count: count_posts)['items']
  end

  def get_topics
    #todo
  end

  def get_post_comments(post, group_id)
    puts 'Количество комментариев:'
    comments_offset = 0
    comments_offset = post['comments']['count'] - 99 if post['comments']['count'] > 99
    VK.wall.get_comments(access_token: TOKEN,
                           owner_id: -group_id,
                           post_id: post.id,
                           offset: comments_offset,
                           count: 99)['items']
  end

  def get_topic_comments
    #todo
  end

  def check_keyword(keywords, text)
    (keywords & text.split)
  end
end
