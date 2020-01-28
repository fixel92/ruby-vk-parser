# frozen_string_literal: true

VkontakteApi.configure do |config|
  config.api_version = '5.74'
end
SERVICE_TOKEN = ENV['SERVICE_TOKEN_VK']

OPTIONS = { address: 'smtp.gmail.com',
            port: 587,
            user_name: ENV['EMAIL_FROM'],
            password: ENV['EMAIL_FROM_PASSWORD'],
            authentication: 'plain',
            enable_starttls_auto: true }.freeze
