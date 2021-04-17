class HtmlSender
  def send(data)
    File.write('my_output.html', html_body(data), mode: 'w')
  end

  private

  def prepare_keywords_labels(keywords)
    keywords.map do |keyword|
      "<span class='ui teal tiny label'>#{keyword}</span>"
    end.join(' ')
  end

  def prepare_rows(data)
    data.values.map do |i|
      %(
      <tr>
        <td>#{i[:type]}</td>
        <td><small>#{i[:text]}</small></td>
        <td><b>#{i[:date]}</b></td>
        <td><small><a href="#{i[:url]}" target="_blank">Перейти</a></small></td>
        <td><span class="ui teal tiny label">#{prepare_keywords_labels(i[:keywords])}</td>
      </tr>
    )
    end.join(' ')
  end

  def html_body(data)
    %(
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Результаты парсинга</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.js"></script>
      </head>
      <body>
      <style type="text/css">
        A:visited {
          color: #80007a;
        }
      </style>
        <h2 class="ui center aligned header">Ссылки на посты и комментарии по ключевым словам:</h2>
        <table class="ui celled padded table">
          <thead>
            <tr>
              <th>Тип записи</th>
              <th>Текст</th>
              <th>Дата</th>
              <th>Ссылка</th>
              <th>Ключевые слова</th>
            </tr>
          </thead>
          <tbody>
            #{prepare_rows(data)}
          </tbody>
        </table>
      </body>
      </html>
    )
  end
end
