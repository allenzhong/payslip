require "spec_helper"
RSpec.describe 'Tax Rules' do
  describe 'should follow the rules. When Taxable Income is in' do
    it '0 - $18200, Tax is nil' do
      annual_salary = 18000
      expect_tax = 0
      @tax_rule = CurrentTaxRule.new
      result_tax = @tax_rule.taxable_income(annual_salary)
      expect(result_tax).to eq(expect_tax)
    end

    describe '$18,201 -­ $37,000, Tax is 19c for each $1 over $18,200' do
      it 'with rounded up result' do
        annual_salary = 32066
        # (32066-18201) * 0.19 / 12 = 219.52 = 220
        expect_tax = 220
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
      it 'with rounded down result' do
        annual_salary = 32000
        # (32000-18201) * 0.19 / 12 = 218.484 = 218
        expect_tax = 218
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
    end

    describe '$37,001 -­‐ $80,000, Tax is $3,572 plus 32.5c for each $1 over $37,000' do
      it 'with rounded up result' do
        annual_salary = 49999
        # (3572 + (49999-37001) * 0.325) / 12 = 649.6958333333333 = 650
        expect_tax = 650
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
      it 'with rounded down result' do
        annual_salary = 48800
        # (3572 + (48800-37001) * 0.325) / 12 = 617.2229166666667 = 617
        expect_tax = 617
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
    end

    describe '$80,001 -­‐ $180,000, Tax is $17,547 plus 37c for each $1 over $80,000' do
      it 'with rounded up result' do
        annual_salary = 88800
        # (17547 + (88800-80001) * 0.37) / 12 = 1733.5525 = 1734
        expect_tax = 1734
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
      it 'with rounded down result' do
        annual_salary = 92200
        # (17547 + (92200-80001) * 0.37) / 12 = 1838.3858333333335 = 1838
        expect_tax = 1838
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
    end

    describe '$180,001 and over, Tax is $54,547 plus 45c for each $1 over $180,000' do
      it 'with rounded up result' do
        annual_salary = 210000
        # (54,547 + (210000-180001) * 0.45) / 12 = 5670.545833333334 = 5671
        expect_tax = 5671
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
      it 'with rounded down result' do
        annual_salary = 192200
        # (54547 + (192200-180001) * 0.45) / 12 = 5003.045833333334 = 5003
        expect_tax = 5003
        @tax_rule = CurrentTaxRule.new
        result_tax = @tax_rule.taxable_income(annual_salary)
        expect(result_tax).to eq(expect_tax)
      end
    end
  end
end
