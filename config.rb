# frozen_string_literal: true

require 'mail'
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
require_relative 'lib/getters/csv_getter'

VkontakteApi.configure do |config|
  config.api_version = '5.74'
end
SERVICE_TOKEN = ENV['SERVICE_TOKEN_VK']

Mail.defaults do
  delivery_method :smtp, { address: 'smtp.gmail.com',
                           port: 587,
                           user_name: ENV['EMAIL_FROM'],
                           password: ENV['EMAIL_FROM_PASSWORD'],
                           authentication: 'plain',
                           enable_starttls_auto: true }.freeze
end