require 'uri'

class Output

  def initialize(messages)
    @messages = messages
  end


  def cleaning_messages
    @messages.delete([])
  end

  def check_records_count
    cleaning_messages

    abort("\nНет записей") if @messages.empty?
  end

  def title
    'Ссылки на посты и комментарии по ключевым словам:'
  end

  def records_output
    "#{title}\n\n#{@messages.join("\n")}"
  end

  def send_email



    Mail.new(
      to: ENV['EMAIL_TO'],
      from: ENV['EMAIL_FROM'],
      subject: 'Парсер ВК',
      body: records_output
    ).deliver!
  end

  def send_in_txt
    abort("\nНет записей") if @messages.empty?

    File.write('my_output.txt', records_output, mode: 'w')
  end

  def send_in_html
    abort("\nНет записей") if @messages.empty?

    text = @messages.map do |i|
      '<li><a target="_blank" href=' + "#{URI.extract(i).first}" + '>' + "#{i}" + '</a></li>'
    end.join(' ')

    list = '<ul style="list-style-type: none">' + text + '</ul>'
    template = '<html><style>a{text-decoration: none;}</style><body>' \
               "<h1>#{title}</h1>#{list}</body></html>"

    File.write('my_output.html', template, mode: 'w')
  end
end
