require 'csv'
require 'fileutils'
require "spec_helper"
RSpec.describe 'Payslip Generator' do
  describe 'should read file correctly' do
    before do
      @temp_written_csv_file_name = 'temp_test_data.csv'
      @payslip_generator = PayslipGenerator.new

      @array_of_csv_data_ready_to_write = [
          ['David','Rudd','60050','9%','01 March – 31 March'],
          ['Ryan','Chen','120000','10%','01 March – 31 March']
      ]
      CSV.open(@temp_written_csv_file_name, 'w') do |temp_csv|
        @array_of_csv_data_ready_to_write.each do |each_person|
          temp_csv << each_person
        end
      end
    end

    after do
      FileUtils.rm_f @temp_written_csv_file_name
    end

    it 'should read CVS file correctly and return an array if file exists' do
      people_array = @payslip_generator.read_file(@temp_written_csv_file_name)
      expect(people_array.count).to eq(2)
    end
  end

  describe "should generate file" do
    before(:each) do
      @temp_written_csv_file_name = 'result.csv'
      person = Person.new
      person.first_name = 'David'
      person.last_name = 'Rudd'
      person.annual_salary = 60050
      person.super_rate = 9
      person.payment_start_date = '01 March – 31 March'
      @input_mock_peope_array = []
      @input_mock_peope_array << person

      @payslip_generator = PayslipGenerator.new
    end

    after do
      FileUtils.rm_f @temp_written_csv_file_name
    end

    it 'corretly when the array consist of people is not nil' do
      file_name = @payslip_generator.generate_file(@temp_written_csv_file_name, @input_mock_peope_array)
      expect(File.exist?(file_name)).to be_truthy
    end

    it 'failed and raise an error when the array is nil' do
      expect {
        @payslip_generator.generate_file(@temp_written_csv_file_name, [])
      }.to raise_error(DataError)
    end
  end
end
