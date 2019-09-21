#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'lib/type'
require_relative 'lib/group'
require_relative 'lib/post'
require_relative 'lib/comment'
require_relative 'data'

group_ids = Group.new.objects(urls: URLS)
messages = []
group_ids.each do |item|
   posts = Post.new(group_id: item['id']).objects(post_count: 3)
   if posts.empty?
     messages << 'Не получены посты группы https://vk.com/public' +
                 Group.new.surname(item['id'])[0]['id'].to_s
   else
     posts.each do |post|
       # new_post = Post.new(group_id: item['id'])
       # if new_post.text_fits?(KEYWORDS, ANTI_KEYWORDS, post['text'])
       #   messages << new_post.message(post, KEYWORDS)
       # end
       comments = Comment.new(group_id: item['id'], post: post)
       messages << comments.check if comments.non_zero?
     end
   end
   end
puts messages
