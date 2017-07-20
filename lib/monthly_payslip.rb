require 'bigdecimal'

class MonthlyPayslip
  def initialize(annual_salary=0, super_rate=0, pay_period='', tax_rule=CurrentTaxRule.new)
    @annual_salary = annual_salary
    @super_rate = super_rate
    @pay_period = pay_period
    @tax_rule = tax_rule
  end

  def pay_period
    @pay_period
  end

  def pay_period=(value)
    @pay_period = value
  end

  def gross_income
    @gross_income ||= (BigDecimal.new(@annual_salary) / 12).round 
  end

  def gross_income=(value)
    @gross_income = value
  end

  def taxable_income()
    @taxable_income ||= @tax_rule.taxable_income(@annual_salary)
  end

  def taxable_income=(value)
    @taxable_income = value
  end

  def net_income
    @net_income ||= (self.gross_income - self.taxable_income)  
  end

  def net_income=(value)
    @net_income = value
  end

  # Because super is a keywrod in Ruby, it should be change a name
  def super_value
    @super_value ||= (BigDecimal.new(self.gross_income) * @super_rate / 100).round
  end

  def super_value=(value)
    @super_value = value
  end
end
