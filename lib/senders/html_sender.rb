class HtmlSender
  def send(data)
    File.write('my_output.html', repare_data(data), mode: 'w')
  end

  def repare_data(data)
    text = data.values.map do |i|
      "<li><a target='_blank' href='#{URI.extract(i[:url])}'>#{i[:type]} - #{i[:url]} - #{i[:keywords]}\n</a></li>"
    end.join(' ')

    list = "<ul style='list-style-type: none'>#{text}</ul>"

    '<html><style>a{text-decoration: none;}</style><body>' \
               "<h1>#{title}</h1>#{list}</body></html>"
  end

  def title
    'Ссылки на посты и комментарии по ключевым словам:'
  end
end
