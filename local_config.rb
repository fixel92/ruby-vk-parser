# use gems:
# https://github.com/mikel/mail
# https://github.com/7even/vkontakte_api
# https://rubygems.org/gems/sqlite3/versions/1.3.11

# Внести свои данные и переименовать файл в config.rb
VkontakteApi.configure do |config|
  # используемая версия API
  config.api_version = '5.74'
end
@service_token = '********************************************' # Токен сообщества
