# frozen_string_literal: true

require 'vkontakte_api'
require_relative 'type'
require 'pry'

class Comment < Type
  attr_reader :id, :group_id, :post, :vk

  def initialize(params = {})
    super
    @group_id = params[:group_id]
    @post = params[:post]
  end

  def objects(post)
    comments_offset = 0
    comments_offset = post['comments']['count'] - 99 if post['comments']['count'] > 99
    sleep(1)
    @vk.wall.get_comments(access_token: SERVICE_TOKEN,
                          owner_id: -@group_id,
                          post_id: @post.id,
                          offset: comments_offset,
                          count: 99)['items']
  end

  def non_zero?
    @post['comments']['count'].nonzero?
  end

  def reply_comment(comment)
    if comment['reply_to_comment'].nil?
      ''
    else
      "-&thred=#{comment['reply_to_comment']}"
    end
  end

  def message(comment)
    "Комментарий https://vk.com/wall#{-@group_id}_#{@post.id}" \
    "?reply=#{comment.id}+#{reply_comment(comment)}" \
      "&w=wall#{-@group_id}_#{@post.id}_r#{comment.id} -" +
      check_keyword(KEYWORDS, comment['text']).to_s
  end

  def check
    messages = []
    objects(@post).each do |comment|
      if text_fits?(KEYWORDS, ANTI_KEYWORDS, comment['text'])
        messages << message(comment)
      else
        next
      end
    end
    messages - []
  end
end

