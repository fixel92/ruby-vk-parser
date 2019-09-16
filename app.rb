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
      if group.text_fits?(KEYWORDS, ANTI_KEYWORDS, post['text'])
        messages << group.post_message(post, KEYWORDS)
      else
        puts 'Нет совпадений'

        if post['comments']['count'].nonzero?
          comments = group.get_post_comments(post, group.group_id)
          comments.each do |comment|
            next unless group.text_fits?(KEYWORDS, ANTI_KEYWORDS, comment['text'])

            messages << group.comment_message(post, comment, KEYWORDS)
          end
        else
          next
        end
      end
    end
  end
end
puts messages.to_s