require 'vkontakte_api'
require_relative 'type'
require 'pry'

class Post < Type
  attr_reader :id, :group_id, :vk

  def initialize(params = {})
    super
    @group_id = params[:group_id]
  end

  def objects(params = {})
    sleep(1)
    begin
    @vk.wall.get(owner_id: "-#{@group_id}", count: params[:post_count])['items']
    rescue VkontakteApi::Error => e
      puts e
      return []
    end
  end

  def message(post, keywords)
    "https://vk.com/wall#{-@group_id}_#{post['id']} -" +
      check_keyword(keywords, post['text']).to_s
  end
end




