VkontakteApi.configure do |config|
  # API version
  config.api_version = '5.74'
end
SERVICE_TOKEN = '********************************************' # Token community

OPTIONS = { address: 'smtp.gmail.com', # Params for SMTP
            port: 587,
            user_name: 'YOUR EMAIL',
            password: 'YOUR PASSWORD',
            authentication: 'plain',
            enable_starttls_auto: true }.freeze