require 'csv'
require 'fileutils'
require 'byebug'

class DataError < StandardError
  def initialize(msg = "Please check if data is empty or wrong")
    super(msg)
  end
end

class PayslipGenerator
  def initialize
    @people_array = []
  end

  def read_file(csv_file_name)
    File.open(csv_file_name).each do |line_with_comma_separated_attributes|
      person = Person.new
      person.interprete_comma_separated_string(line_with_comma_separated_attributes)
      @people_array << person
    end
    @people_array
  end 

  def generate_file(csv_file_name='output.csv', data = @people_array)
    if data.empty?
      raise DataError
    end

    CSV.open(csv_file_name, 'w') do |csv|
      @people_array.each do |person|
        csv << person.query_payslip.split(',')
      end
    end    
    csv_file_name
  end
end
