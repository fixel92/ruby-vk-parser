class GoogleCsvSender
  COLS = [
    [1, :type],
    [2, :text],
    [3, :date],
    [4, :url],
    [5, :keywords]
  ].freeze

  def send(data)
    create_folder
    remove_old_file
    create_file
    insert_data(data)
  end

  private

  def session
    @session ||= GoogleDrive::Session.from_config('client_secret.json')
  end

  def ws
    @ws ||= session.spreadsheet_by_name('ruby_vk_parser_csv').worksheets[0]
  end

  def create_folder
    session.create_folder('ruby-vk-parser') if session.folders_by_name('ruby-vk-parser').nil?
  end

  def remove_old_file
    session.spreadsheet_by_name('ruby_vk_parser_csv')&.delete(true)
  end

  def create_file
    session.folders_by_name('ruby-vk-parser').create_spreadsheet('ruby_vk_parser_csv')
    ws[1, 1] = 'Тип записи'
    ws[1, 2] = 'Текст'
    ws[1, 3] = 'Дата'
    ws[1, 4] = 'Ссылка'
    ws[1, 5] = 'Ключевые слова'
    ws.save
  end

  def insert_data_in_row(comment)
    row = comment.first + 2
    COLS.each do |col|
      ws[row, col[0]] = comment[1][col[1]]
    end
  end

  def insert_data(data)
    data.each do |comment|
      insert_data_in_row(comment)
    end
    ws.save
  end
end
