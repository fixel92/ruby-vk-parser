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
  new_post = Post.new(group_id: item['id'])
  posts = new_post.objects(post_count: '3')
  if posts.empty?
    messages << 'Не получены посты группы https://vk.com/public' +
                Group.new.surname(item['id'])[0]['id'].to_s
  else

    messages << new_post.check(posts) unless new_post.check(posts).nil?
    posts.each do |post|
      comments = Comment.new(group_id: item['id'], post: post)
      messages << comments.check if comments.non_zero?
    end
  end
end
puts messages
