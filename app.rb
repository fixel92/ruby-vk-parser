#!/usr/bin/ruby

require 'dotenv/load'
require 'json'
require 'vkontakte_api'
require_relative 'config'
require 'mail'

output_type = case ARGV[0]
              when '--email'
                EmailSender.new
              when '--txt'
                TxtSender.new
              when '--html'
                HtmlSender.new
              when '--json'
                JsonSender.new
              else
                TxtSender.new
              end

group_ids = Group.new.objects(urls: DataGroupKey.urls) # get groups
messages = []

group_ids.each do |group|
  [Topic, Post].each do |i|
    i.get_valid(group['id']).each { |item| messages << item }
  end
end

records = OutputGenerator.new(messages).generate_records
if records.nil?
  puts 'Not found'
else
  Output.new.send_report(output_type, records)
  puts 'Done'
end
