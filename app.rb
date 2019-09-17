#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'lib/type'
require_relative 'lib/group'
require_relative 'lib/post'

@file_path = File.dirname(__FILE__)

def check_file(file)
  if File.exist?(@file_path + "/data/#{file}.txt")
    File.read(@file_path + "/data/#{file}.txt").split("\n").uniq
  else
    puts "Не найден файл с #{file} групп вконтакте"
  end
end

def upgrade_keywords(keys)
  keywords = []
  keys.each do |key|
    keywords << key.capitalize.to_s
    keywords << key.upcase.to_s
    keywords << key.to_s
    keywords << "#{key} "
    keywords << " #{key}"
    keywords << "#{key}?"
    keywords << "#{key}."
    keywords << "#{key}!"
  end
  keywords
end

URLS = check_file('urls')
KEYWORDS = upgrade_keywords(check_file('keywords'))
ANTI_KEYWORDS = upgrade_keywords(check_file('anti_keywords'))

group_ids = Group.new.objects(urls: URLS)
messages = []

group_ids.each do |item|
  new_post = Post.new(group_id: item['id'])
  posts = Post.new(group_id: item['id']).objects(post_count: 5)
  if posts.empty?
    messages << 'Не получены посты группы https://vk.com/public' +
                Group.new.surname(item['id'])[0]['id'].to_s
  else
    posts.each do |post|
      if new_post.text_fits?(KEYWORDS, ANTI_KEYWORDS, post['text'])
        messages << new_post.message(post, KEYWORDS)
      else
        puts 'Нет совпадений'

        # if post['comments']['count'].nonzero?
        #   comments = group.get_post_comments(post, group.group_id)
        #   comments.each do |comment|
        #     next unless group.text_fits?(KEYWORDS, ANTI_KEYWORDS, comment['text'])
        #
        #     messages << group.comment_message(post, comment, KEYWORDS)
        #   end
        # else
        #   next
        # end
      end
    end
  end
end
puts messages.to_s