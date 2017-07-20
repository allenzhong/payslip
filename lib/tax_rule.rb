#Abstract class for strategy pattern
class TaxRule
  def taxable_income(annual_salary=0)
    raise NoMethodError
  end
end

# For current tax rules 
class CurrentTaxRule < TaxRule
  def taxable_income(annual_salary=0)
    case annual_salary
    when 0..18200
      @taxable_income = 0
    when 18201..37000
      @taxable_income = (BigDecimal.new(annual_salary - 18201) * 0.19 / 12).round
    when 37001..80000
      @taxable_income = ((3572 + BigDecimal.new(annual_salary - 37001) * 0.325) / 12).round
    when 80001..180000
      @taxable_income = ((17547 + BigDecimal.new(annual_salary-80001) * 0.37) / 12).round
    else
      @taxable_income = ((54547 + BigDecimal.new(annual_salary-180001) * 0.45) / 12 ).round
    end
    @taxable_income
  end
end
