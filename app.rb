#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'lib/type'
require_relative 'lib/group'
require_relative 'lib/post'
require_relative 'lib/topic'
require_relative 'lib/comment'
require_relative 'data'
require 'pry'

time1 = Time.new
puts "Current Time : " + time1.inspect

group_ids = Group.new.objects(urls: URLS)
messages = []
group_ids.each do |group|
  topics = Topic.new(group_id: group['id']).objects(topic_counts: 90)
  topics.each do |topic|
    comments_topic = Comment.new(group_id: group['id'], post: topic)
    messages << comments_topic.check('topic') if topic['comments'].nonzero?
  end

  new_post = Post.new(group_id: group['id'])
  posts = new_post.objects(post_count: 20)
  if posts.empty?
    messages << 'Не получены посты группы https://vk.com/public' +
                Group.new.surname(group['id'])[0]['id'].to_s
  else
    messages << new_post.check(posts) unless new_post.check(posts).nil?
    posts.each do |post|
      comments_post = Comment.new(group_id: group['id'], post: post)
      messages << comments_post.check('post') if comments_post.non_zero?
    end
  end
end
puts messages
time2 = Time.new
puts "Current Time : " + time2.inspect
