#!/usr/bin/ruby
# frozen_string_literal: true

require 'vkontakte_api'
require_relative 'config'
require_relative './lib/group'

urls = %w[https://vk.com/batumihelp https://vk.com/forum_georgia https://vk.com/batumi35]

group_ids = Group.get_groups_id(urls)

group_ids.each do |item|
  group = Group.new(item['id'])
  posts = group.get_posts(3)
  posts.each do |post|
    puts post['text']
  end
end