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
require_relative 'lib/output'
require 'mail'

group_ids = Group.new.objects(urls: DataGroupKey.urls) # get groups
messages = []

group_ids.each do |group|
  Topic.get_valid(group['id']).each { |item| messages << item }
  Post.get_valid(group['id']).each { |item| messages << item }
end

output = Output.new(messages)
output.check_records_count

output.send_in_txt
