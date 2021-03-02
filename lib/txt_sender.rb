class TxtSender
  def send(data)
    File.write('my_output.txt', "#{title}\n\n#{data}", mode: 'w')
  end

  def title
    'Ссылки на посты и комментарии по ключевым словам:'
  end
end
