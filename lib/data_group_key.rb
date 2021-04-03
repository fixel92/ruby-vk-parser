module DataGroupKey
  def self.urls
    File.read("#{__dir__}/../data/urls.txt").split("\n").uniq
  end

  def check_file(file)
    File.read("#{__dir__}/../data/#{file}.txt").split("\n").uniq
  end

  def upgrade_keywords(keys)
    keys.map(&:downcase)
  end

  def keywords
    upgrade_keywords(check_file('keywords'))
  end

  def anti_keywords
    upgrade_keywords(check_file('anti_keywords'))
  end
end
