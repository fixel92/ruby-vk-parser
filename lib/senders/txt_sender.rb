class TxtSender
  def send(data)
    File.write('my_output.txt', "#{title}\n\n#{prepare_data(data)}", mode: 'w')
  end

  private

  def prepare_data(data)
    data.values.map { |prod| "#{prod[:type]} - #{prod[:url]} - #{prod[:keywords]}" }.join("\n")
  end

  def title
    'Ссылки на посты и комментарии по ключевым словам:'
  end
end
