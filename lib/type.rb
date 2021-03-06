class Type
  attr_reader :id, :vk, :token

  def initialize(_params = {})
    @vk = VkontakteApi::Client.new(SERVICE_TOKEN)
    @token = SERVICE_TOKEN
  end

  def check_date(post_date)
    post_date > Time.now.to_i - DAYS_AGO
  end

  def check_keyword(keywords, text)
    keywords.reject { |key| text.downcase.match(/\b#{key}\b/).nil? }
  end

  # check fits text
  def text_fits?(keywords, anti_keywords, text)
    check_keyword(keywords, text).any? &
      check_keyword(anti_keywords, text).empty?
  end
end
