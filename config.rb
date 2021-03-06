# frozen_string_literal: true

require 'choice'
require 'mail'
require 'pry'
require_relative 'lib/type'
require_relative 'lib/group'
require_relative 'lib/post'
require_relative 'lib/topic'
require_relative 'lib/comment'
require_relative 'lib/database'
require_relative 'lib/output_generator'
require_relative 'lib/output'
require_relative 'lib/senders/email_sender'
require_relative 'lib/senders/html_sender'
require_relative 'lib/senders/txt_sender'
require_relative 'lib/senders/json_sender'
require_relative 'lib/senders/google_csv_sender'
require_relative 'lib/senders/online_table_sender'
require_relative 'lib/getters/csv_getter'
require_relative 'lib/getters/google_csv_getter'

REQUESTS_INTERVAL = 0.5 # time between requests
GMAIL = ENV['GMAIL']
SERVICE_TOKEN = ENV['SERVICE_TOKEN_VK']

VkontakteApi.configure do |config|
  config.api_version = '5.74'
end

Mail.defaults do
  delivery_method :smtp, { address: 'smtp.gmail.com',
                           port: 587,
                           user_name: ENV['EMAIL_FROM'],
                           password: ENV['EMAIL_FROM_PASSWORD'],
                           authentication: 'plain',
                           enable_starttls_auto: true }.freeze
end

Choice.options do
  header ''
  header 'Specific options:'

  option :input do
    short '-i'
    long '--input=csv'
    desc 'Source of input (default csv)'
    default 'csv'
    valid %w[csv google_csv]
  end

  option :output do
    short '-o'
    long '--output=[email|txt|html|json|google_csv]'
    desc 'Output (default html)'
    default 'html'
    valid %w[email txt html json google_csv online_table]
  end

  option :days_ago do
    short '-d'
    long '--days_ago=1-180'
    desc 'Find records before days ago (default 14)'
    default 14
    cast Integer
  end

  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

DAYS_AGO = 24 * 60 * 60 * Choice['days_ago']

OUTPUT = {
  'email' => EmailSender.new,
  'txt' => TxtSender.new,
  'html' => HtmlSender.new,
  'json' => JsonSender.new,
  'online_table' => OnlineTableSender.new,
  'google_csv' => GoogleCsvSender.new
}.freeze

INPUT = {
  'csv' => CsvGetter.new.call,
  'google_csv' => GoogleCsvGetter.new.call
}.freeze
