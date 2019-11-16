module DataGroupKey
  def self.urls
    File.read("#{__dir__}/../data/urls.txt").split("\n").uniq
  end

  def check_file(file)
    File.read("#{__dir__}/../data/#{file}.txt").split("\n").uniq
  end

  def upgrade_keywords(keys)
    keywords = []
    keys.each do |key|
      keywords << key.to_s
      keywords << key.capitalize.to_s
      keywords << key.upcase.to_s
    end
    keywords
  end

  def keywords
    upgrade_keywords(check_file('keywords'))
  end

  def anti_keywords
    upgrade_keywords(check_file('anti_keywords'))
  end
end
