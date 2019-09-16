#!/usr/bin/ruby
# frozen_string_literal: true

require 'vkontakte_api'
require_relative 'config'
require_relative './lib/group'

@file_path = File.dirname(__FILE__)

def check_file(file)
  if File.exist?(@file_path + "/data/#{file}.txt")
    File.read(@file_path + "/data/#{file}.txt").split("\n").uniq
  else
    puts "Не найден файл с #{file} групп вконтакте"
  end
end

URLS = check_file('urls')
KEYWORDS = check_file('keywords')
ANTI_KEYWORDS = check_file('anti_keywords')

group_ids = Group.get_group_ids(URLS)
messages = []
group_ids.each do |item|
  group = Group.new(item['id'])
  posts = group.get_posts(5)
  sleep(1.5)
  if posts.empty?
    puts "Не получены посты группы #{group.group_id}"

    next
  else
    posts.each do |post|
      if group.check_keyword(KEYWORDS, post['text']).any? &
         group.check_keyword(ANTI_KEYWORDS, post['text']).empty?

        messages << "https://vk.com/wall#{-group.group_id}_#{post.id} -" +
                    group.check_keyword(KEYWORDS, post['text']).to_s
      else
        puts 'Нет совпадений'

        if post['comments']['count'].nonzero?
          comments = group.get_post_comments(post, group.group_id)
          sleep(1.5)
          comments.each do |comment|
            next unless group.check_keyword(KEYWORDS, comment['text']).any? &
                        group.check_keyword(ANTI_KEYWORDS, comment['text']).empty?
            puts comment
            if comment['reply_to_comment']
              messages << message(
                  "#{-group.group_id}_#{post.id}" +
                  "?reply=#{comment.id}&thred=#{comment['reply_to_comment']}-" +
                  group.check_keyword(KEYWORDS, comment['text']).to_s
              )
            else
              messages << "Комментарий https://vk.com/wall#{-group.group_id}_#{post.id}"+
                          "?reply=#{comment.id} - #{group.check_keyword(KEYWORDS, comment['text'])}"
            end
          end
        else
          next
        end
      end
    end
  end
end
puts messages.to_s