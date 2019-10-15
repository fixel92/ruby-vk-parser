#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'lib/type'
require_relative 'lib/group'
require_relative 'lib/post'
require_relative 'lib/topic'
require_relative 'lib/comment'
require_relative 'lib/database'
require_relative 'data'
require 'mail'

group_ids = Group.new.objects(urls: URLS) # get groups
messages = []

group_ids.each do |group|
  # get topics
  topics = Topic.new(group_id: group['id']).objects(topic_counts: 30)
  topics.each do |topic|
    comments_topic = Comment.new(group_id: group['id'], post: topic)
    # check comments topic and send in message
    if topic['comments'].nonzero?
      comments_topic.check('topic_comments').each { |item| messages << item }
    end
  end

  new_post = Post.new(group_id: group['id'])
  posts = new_post.objects(post_count: 20) # get posts
  if posts.empty?
    messages << 'Не получены посты группы https://vk.com/public' +
                Group.new.surname(group['id'])[0]['id'].to_s
  else
    # check posts and send in message
    new_post.check(posts).each { |item| messages << item }
    posts.each do |post|
      comments_post = Comment.new(group_id: group['id'], post: post)
      # check comments post and send in message
      if comments_post.non_zero?
        comments_post.check('post_comments').each { |item| messages << item }
      end
    end
  end
end
messages.delete([])

if messages.any?
  Mail.defaults do
    delivery_method :smtp, OPTIONS
  end

  Mail.deliver do
    to ['kombo92@yandex.ru']
    from 'iridabatumi@gmail.com'
    subject 'Парсер ВК'
    body "Ссылки на посты и комментарии по ключевым словам:\n\n#{messages.join("\n")}"
  end
else
  puts('Нет записей')
end

