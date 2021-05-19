class EmailSender
  def send(data)
    Mail.new(
      to: ENV['EMAIL_TO'],
      from: ENV['EMAIL_FROM'],
      subject: 'Парсер ВК',
      content_type: 'text/html; charset=UTF-8',
      body: html_body(data)
    ).deliver!
  end

  private

  def prepare_data(data)
    data.values.map { |prod| "#{prod[:type]} - #{prod[:url]} - #{prod[:keywords]}" }.join("\n")
  end

  def prepare_keywords_labels(keywords)
    keywords.map do |keyword|
      "<span style='background-color: #bebebe; color: #fff;'>#{keyword}</span>"
    end.join(' ')
  end

  def image(value)
    %(<img src="#{value[:image]}" width="100px">) if value[:image]
  end

  def prepare_rows(data)
    data.values.map do |i|
      %(
      <tr>
        <td>#{i[:type]}</td>
        <td>#{image(i)}</td>
        <td><small>#{i[:text]}</small></td>
        <td><b>#{i[:date]}</b></td>
        <td><small><a href="#{i[:url]}" target="_blank">Перейти</a></small></td>
        <td>#{prepare_keywords_labels(i[:keywords])}</td>
      </tr>
    )
    end.join(' ')
  end

  def html_body(data)
    %(
      <!DOCTYPE html>
      <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <meta name="x-apple-disable-message-reformatting">
        <title></title>
        <!--[if mso]>
        <noscript>
          <xml>
            <o:OfficeDocumentSettings>
              <o:PixelsPerInch>96</o:PixelsPerInch>
            </o:OfficeDocumentSettings>
          </xml>
        </noscript>
        <![endif]-->
        <style>
          table,
          td,
          div,
          h1,
          p {
            font-family: Arial, sans-serif;
          }
        </style>
      </head>

      <body style="margin:0;padding:0;">
        <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;background:#ffffff;">
          <tr>
            <td align="center" style="padding:0;">
              <table role="presentation"
                style="width:802px;border-collapse:collapse;border:1px solid #cccccc;border-spacing:0;text-align:left;">
                <tr>
                  <td style="padding:36px 30px 42px 30px;">
                    <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;">
                      <thead>
                        <tr>
                          <th>Тип записи</th>
                          <th>Изображение</th>
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
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </body>
      </html>
    )
  end
end
