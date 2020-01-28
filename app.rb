#!/usr/bin/ruby

require 'dotenv/load'
require 'vkontakte_api'
require_relative 'config'
require_relative 'lib/data_group_key'
require_relative 'lib/type'
require_relative 'lib/group'
require_relative 'lib/post'
require_relative 'lib/topic'
require_relative 'lib/comment'
require_relative 'lib/database'
require 'mail'

group_ids = Group.new.objects(urls: DataGroupKey.urls) # get groups
messages = []

group_ids.each do |group|
  Topic.get_valid(group['id']).each { |item| messages << item }
  Post.get_valid(group['id']).each { |item| messages << item }
end
messages.delete([])

if messages.any?
  Mail.defaults do
    delivery_method :smtp, OPTIONS
  end

  Mail.deliver do
    to ENV['EMAIL_TO']
    from ENV['EMAIL_FROM']
    subject 'Парсер ВК'
    body "Ссылки на посты и комментарии по ключевым словам:\n\n#{messages.join("\n")}"
  end
else
  puts('Нет записей')
end

