class EmailSender
  def send(data)
    Mail.new(
      to: ENV['EMAIL_TO'],
      from: ENV['EMAIL_FROM'],
      subject: 'Парсер ВК',
      body: data
    ).deliver!
  end
end
