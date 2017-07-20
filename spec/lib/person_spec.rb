require "spec_helper"
RSpec.describe 'Payslip Person' do
  describe 'should be initiallized ' do
    before(:each) do
      @string_represent_person = 'David,Rudd,60050,9%,01 March – 31 March'
    end

    it 'with a string that can be interpreted' do
      person = Person.new()
      person.interprete_comma_separated_string(@string_represent_person)
      expect(person.first_name).to eq('David')
      expect(person.last_name).to eq('Rudd')
      expect(person.annual_salary).to eq(BigDecimal.new(60050))
      expect(person.super_rate).to eq(9)
    end
  end

  describe 'Name' do
    it 'should be in conventional format as first_name at first and then last_name' do
      first_name = 'Allen'
      last_name = 'Zhong'
      person = Person.new
      person.first_name = first_name
      person.last_name = last_name
      expect_name = "#{first_name} #{last_name}"
      result_name = person.name
      expect(result_name).to eq(expect_name)
    end
  end

  describe 'should generate string' do
    before do
      @person = Person.new
      @person.first_name = 'David'
      @person.last_name = 'Rudd'
      @person.annual_salary = 60050
      @person.super_rate = 9
    end

    it 'that can be used to write into CSV file accordance with attributes in person and payslip' do
      expect_output_string = 'David Rudd,01 March – 31 March,5004,922,4082,450'
      expect(@person.query_payslip('01 March – 31 March')).to eq(expect_output_string)
    end
  end
end
