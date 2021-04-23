#!/usr/bin/ruby

require 'dotenv/load'
require 'json'
require 'vkontakte_api'
require 'google_drive'
require_relative 'config'
require 'mail'
require 'pry'

output_type = case ARGV[0]
              when '--email'
                EmailSender.new
              when '--txt'
                TxtSender.new
              when '--html'
                HtmlSender.new
              when '--json'
                JsonSender.new
              when '--google_csv'
                GoogleCsvSender.new
              else
                TxtSender.new
              end

input_data = CsvGetter.new.call

group_ids = Group.new.objects(urls: input_data[:urls]) # get groups
messages = []

group_ids.each do |group|
  [Topic, Post].each do |i|
    i.get_valid(group['id'], input_data).each { |item| messages << item }
  end
end

messages = messages.sort_by { |item| Date.parse(item[:date]) }.reverse

records = OutputGenerator.new(messages).generate_records
if records.nil?
  puts 'Not found'
else
  Output.new.send_report(output_type, records)
  puts 'Done'
end
