require 'csv'

class CsvGetter
  def call
    { urls: get_column(:urls),
      keywords: get_column(:keywords).map(&:downcase),
      anti_keywords: get_column(:anti_keywords).map(&:downcase) }
  end

  private

  def prepare_data
    @prepare_data ||= CSV.read('./data/input_data.csv', { headers: true, header_converters: :symbol })
  end

  def get_column(name)
    prepare_data[name].compact.uniq
  end
end
