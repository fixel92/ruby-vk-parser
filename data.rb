# frozen_string_literal: true

@file_path = File.dirname(__FILE__)

def check_file(file)
  if File.exist?(@file_path + "/data/#{file}.txt")
    File.read(@file_path + "/data/#{file}.txt").split("\n").uniq
  else
    puts "Не найден файл с #{file} групп вконтакте"
  end
end

def upgrade_keywords(keys)
  keywords = []
  keys.each do |key|
    keywords << key.capitalize.to_s
    keywords << key.upcase.to_s
    keywords << key.to_s
    keywords << "#{key} "
    keywords << " #{key}"
    keywords << "#{key}?"
    keywords << "#{key}."
    keywords << "#{key}!"
  end
  keywords
end

URLS = check_file('urls')
KEYWORDS = upgrade_keywords(check_file('keywords'))
ANTI_KEYWORDS = upgrade_keywords(check_file('anti_keywords'))
