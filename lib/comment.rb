# frozen_string_literal: true

require 'vkontakte_api'
require_relative '../config'
require_relative 'type'
require 'pry'

class Comment < Type
  attr_reader :id, :group_id, :vk

  def initialize(params = {})
    super
    @group_id = params[:group_id]
  end

  def objects(group_id, post)
    puts 'Количество комментариев:'
    comments_offset = 0
    comments_offset = post['comments']['count'] - 99 if post['comments']['count'] > 99
    @vk.wall.get_comments(access_token: TOKEN,
                         owner_id: -@group_id,
                         post_id: post.id,
                         offset: comments_offset,
                         count: 99)['items']
  end

end



def reply_to_comment(post, comment, keywords)
  'Комментарий https://vk.com/wall'\
      "#{-@group_id}_#{post.id}" \
      "?reply=#{comment.id}&thred=#{comment['reply_to_comment']} - " +
      check_keyword(keywords, comment['text']).to_s
end

def no_reply_to_comment(post, comment, keywords)
  "Комментарий https://vk.com/wall#{-@group_id}_#{post.id}" \
      "?reply=#{comment.id} - #{check_keyword(keywords, comment['text'])}"
end

def comment_message(post, comment, keywords)
  if comment['reply_to_comment']
    reply_to_comment(post, comment, keywords)
  else
    no_reply_to_comment(post, comment, keywords)
  end
end
