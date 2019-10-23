require 'vkontakte_api'
require_relative '../config'
require_relative '../data'

class Type
  attr_reader :id, :vk, :token

  def initialize(_params = {})
    @vk = VkontakteApi::Client.new(SERVICE_TOKEN)
    @token = SERVICE_TOKEN
  end

  def check_date(post_date)
    year_ago_unix = 15778463
    post_date > Time.now.to_i - year_ago_unix
  end

  def check_keyword(keywords, text)
    keywords.select { |key| (text.match(/\b#{key}\b/)) != nil }
  end

  # check fits text
  def text_fits?(keywords, anti_keywords, text)
    check_keyword(keywords, text).any? &
      check_keyword(anti_keywords, text).empty?
  end
end
