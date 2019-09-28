# frozen_string_literal: true

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
      return  @vk.wall.get(owner_id: "-#{@group_id}", count: params[:post_count])['items']
    rescue VkontakteApi::Error => e
      puts e
      return []
    end
  end

  def message(post)
    "https://vk.com/wall#{-@group_id}_#{post['id']} -" +
      check_keyword(KEYWORDS, post['text']).to_s
  end

  def check(posts)
    messages = []
    posts.each do |post|
      if text_fits?(KEYWORDS, ANTI_KEYWORDS, post['text'])
        messages << message(post)
      else
        next
      end
    end
    messages
  end
end
