require 'uri'

class Output
  def send_report(sender, data)
    sender.send(data)
  end
end
