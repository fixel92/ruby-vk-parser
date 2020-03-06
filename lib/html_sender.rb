class HtmlSender
  def send(data)
    text = data.split("\n").map do |i|
      '<li><a target="_blank" href=' + "#{URI.extract(i).first}" + '>' + "#{i}" + '</a></li>'
    end.join(' ')

    list = '<ul style="list-style-type: none">' + text + '</ul>'
    template = '<html><style>a{text-decoration: none;}</style><body>' \
               "<h1>#{title}</h1>#{list}</body></html>"

    File.write('my_output.html', template, mode: 'w')
  end

  def title
    'Ссылки на посты и комментарии по ключевым словам:'
  end
end
