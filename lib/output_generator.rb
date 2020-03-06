class OutputGenerator
  def initialize(messages)
    @messages = messages
  end

  def generate_records
    "#{@messages.join("\n")}" if check
  end

  private

  def cleaning_messages
    @messages.delete([])
  end

  def check
    cleaning_messages

    @messages.any?
  end
end