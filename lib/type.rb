require 'vkontakte_api'
require_relative '../config'
require 'pry'

class Type
  attr_reader :id, :vk, :token

  def initialize(_params = {})
    @vk = VkontakteApi::Client.new(SERVICE_TOKEN)
    @token = SERVICE_TOKEN
  end

  def comments; end

  def check_keyword(keywords, text)
    (keywords & text.split)
  end

  def text_fits?(keywords, anti_keywords, text)
    check_keyword(keywords, text).any? &
      check_keyword(anti_keywords, text).empty?
  end

  def message; end
end
