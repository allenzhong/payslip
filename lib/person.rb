require 'bigdecimal'
class Person
  attr_accessor :first_name, :last_name, :annual_salary, :super_rate, :payment_start_date, :payslips

  def initialize()
    self.payslips = []
  end

  def interprete_comma_separated_string(comma_separated_string_with_attributes_values)
    return if comma_separated_string_with_attributes_values.nil?
    attribute_array = comma_separated_string_with_attributes_values.split(',')
    self.first_name = attribute_array[0]
    self.last_name = attribute_array[1]
    self.annual_salary = BigDecimal.new(attribute_array[2])
    self.super_rate = BigDecimal.new(attribute_array[3])
    self.payment_start_date = attribute_array[4].chop
  end

  def name
    @name ||= "#{self.first_name} #{self.last_name}" 
  end

  def name=(value)
    @name = value
  end

  def query_payslip(payment_start_date = self.payment_start_date)
    queried_payslip = self.payslips.detect {|payslip| payslips.pay_period == payment_start_date}
    queried_payslip ||= MonthlyPayslip.new(self.annual_salary, self.super_rate, payment_start_date) 
    self.payslips << queried_payslip
    
    "#{self.name},#{queried_payslip.pay_period},#{queried_payslip.gross_income},#{queried_payslip.taxable_income},#{queried_payslip.net_income},#{queried_payslip.super_value}"
  end
end
