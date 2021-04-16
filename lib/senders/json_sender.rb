class JsonSender
  def send(data)
    File.write('my_output.json', data.to_json, mode: 'w')
  end
end
