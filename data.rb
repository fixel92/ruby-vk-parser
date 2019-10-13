# frozen_string_literal: true

def check_file(file)
  if File.exist?("#{__dir__}/data/#{file}.txt")
    File.read("#{__dir__}/data/#{file}.txt").split("\n").uniq
  else
    puts "Не найден файл с #{file} групп вконтакте"
  end
end

def upgrade_keywords(keys)
  keywords = []
  chars = %w[! ? , . : ;]
  keys.each do |key|
    keywords << key.to_s
    keywords << key.capitalize.to_s
    keywords << key.upcase.to_s
    chars.each { |char| keywords << key + char }
  end
  keywords
end

URLS = check_file('urls')
KEYWORDS = upgrade_keywords(check_file('keywords'))
ANTI_KEYWORDS = upgrade_keywords(check_file('anti_keywords'))