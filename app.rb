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
require_relative 'lib/output_generator'
require_relative 'lib/output'
require_relative 'lib/email_sender'
require_relative 'lib/html_sender'
require_relative 'lib/txt_sender'
require 'mail'

group_ids = Group.new.objects(urls: DataGroupKey.urls) # get groups
messages = []

group_ids.each do |group|
  [Topic, Post].each do |i|
    i.get_valid(group['id']).each { |item| messages << item }
  end
end

records = OutputGenerator.new(messages).generate_records

Output.new.send_report(TxtSender.new, records) unless records.nil?
