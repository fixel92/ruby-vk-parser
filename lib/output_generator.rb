class OutputGenerator
  def initialize(messages)
    @messages = messages
  end

  def generate_records
    return unless @messages.any?

    result_hash = {}
    @messages.each_with_index do |prod, index|
      result_hash[index] = prod
    end
    result_hash
  end
end
