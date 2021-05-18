require 'csv'

class GoogleCsvGetter
  def call
    abort "File 'getter-ruby-vk-parser' isn't found in Google Drive. Create it." if check_file

    { urls: get_column(:urls).reject(&:empty?),
      keywords: get_column(:keywords).map(&:downcase).reject(&:empty?),
      anti_keywords: get_column(:anti_keywords).map(&:downcase).reject(&:empty?),
      email: get_column(:email).join(',') }
  end

  private

  def session
    @session ||= GoogleDrive::Session.from_config("#{__dir__}/../../client_secret.json")
  end

  def ws
    @ws ||= session.spreadsheet_by_name('getter-ruby-vk-parser').worksheets[0]
  end

  def check_file
    session.spreadsheet_by_name('getter-ruby-vk-parser').nil?
  end

  def get_column(name)
    ws.list.map { |row| row[name] }.compact.uniq
  end
end
