class EmailSender
  def send(data)
    Mail.new(
      to: ENV['EMAIL_TO'],
      from: ENV['EMAIL_FROM'],
      subject: 'Парсер ВК',
      body: prepare_data(data)
    ).deliver!
  end

  private

  def prepare_data(data)
    data.values.map { |prod| "#{prod[:type]} - #{prod[:url]} - #{prod[:keywords]}" }.join("\n")
  end
end
