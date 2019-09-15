#!/usr/bin/ruby
# frozen_string_literal: true

require 'vkontakte_api'
require_relative 'config'
require_relative './lib/group'

@file_path = File.dirname(__FILE__)

def check_file(file)
  if File.exist?(@file_path + "/data/#{file}.txt")
    File.read(@file_path + "/data/#{file}.txt").split("\n")
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
  posts = group.get_posts(3)
  sleep(1.5)
  if posts.empty?
    puts "Не получены посты группы #{@group_id}"
    next
  else
    posts.each do |post|
      if group.check_keyword(KEYWORDS, post['text']).any? &
         group.check_keyword(ANTI_KEYWORDS, post['text']).empty?
        messages << "https://vk.com/wall#{-group.group_id}_#{post.id}
                     - #{group.check_keyword(KEYWORDS, post['text'])}"
      else
        puts 'Нет совпадений'
      end
    end
  end
end
puts messages