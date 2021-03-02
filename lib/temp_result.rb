class TempResult
  def self.save(data)
    File.write('temp_result.txt', data.to_s, mode: 'w')
  end
end
