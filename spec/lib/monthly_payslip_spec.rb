require "spec_helper"

RSpec.describe 'MonthlyPayslip Calculator' do
  describe 'Gross Income' do
    describe 'calculated via formula annual_salary/12 should be ' do
      it 'round up to a integer when the fraction part is greater than or equal 50' do
        # 27607.0/12.0 = 2300.5833333333335
        annual_salary = 27607
        expect_gross_income = 2301
        @payslip = MonthlyPayslip.new(annual_salary)

        result_gross_income = @payslip.gross_income
        expect(result_gross_income).to eq(expect_gross_income)
      end

      it 'round down to a integer when the fraction part is less than 50' do
        # 27607.0/12.0 = 2300.5833333333335
        annual_salary = 60050
        expect_gross_income = 5004
        @payslip = MonthlyPayslip.new(annual_salary)
        result_gross_income = @payslip.gross_income
        expect(result_gross_income).to eq(expect_gross_income)
      end
    end
  end # end Gross Income

  describe 'Income Tax' do
    describe 'should follow the rules. When Taxable Income is in' do
      it '0 - $18200, Tax is nil' do
        annual_salary = 18000
        expect_tax = 0
        @payslip = MonthlyPayslip.new(annual_salary)
        result_tax = @payslip.taxable_income
        expect(result_tax).to eq(expect_tax)
      end

      describe '$18,201 -­ $37,000, Tax is 19c for each $1 over $18,200' do
        it 'with rounded up result' do
          annual_salary = 32066
          # (32066-18201) * 0.19 / 12 = 219.52 = 220
          expect_tax = 220
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
        it 'with rounded down result' do
          annual_salary = 32000
          # (32000-18201) * 0.19 / 12 = 218.484 = 218
          expect_tax = 218
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
      end

      describe '$37,001 -­‐ $80,000, Tax is $3,572 plus 32.5c for each $1 over $37,000' do
        it 'with rounded up result' do
          annual_salary = 49999
          # (3572 + (49999-37001) * 0.325) / 12 = 649.6958333333333 = 650
          expect_tax = 650
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
        it 'with rounded down result' do
          annual_salary = 48800
          # (3572 + (48800-37001) * 0.325) / 12 = 617.2229166666667 = 617
          expect_tax = 617
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
      end

      describe '$80,001 -­‐ $180,000, Tax is $17,547 plus 37c for each $1 over $80,000' do
        it 'with rounded up result' do
          annual_salary = 88800
          # (17547 + (88800-80001) * 0.37) / 12 = 1733.5525 = 1734
          expect_tax = 1734
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
        it 'with rounded down result' do
          annual_salary = 92200
          # (17547 + (92200-80001) * 0.37) / 12 = 1838.3858333333335 = 1838
          expect_tax = 1838
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
      end
      describe '$180,001 and over, Tax is $54,547 plus 45c for each $1 over $180,000' do
        it 'with rounded up result' do
          annual_salary = 210000
          # (54,547 + (210000-180001) * 0.45) / 12 = 5670.545833333334 = 5671
          expect_tax = 5671
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
        it 'with rounded down result' do
          annual_salary = 192200
          # (54547 + (192200-180001) * 0.45) / 12 = 5003.045833333334 = 5003
          expect_tax = 5003
          @payslip = MonthlyPayslip.new(annual_salary)
          result_tax = @payslip.taxable_income
          expect(result_tax).to eq(expect_tax)
        end
      end
    end
  end # end Income Tax test

  describe "Net income" do
    it 'should be caculated by gross income minus income tax' do
      expect_net_income = 4082
      @payslip = MonthlyPayslip.new
      @payslip.gross_income = 5004
      @payslip.taxable_income = 922
      result_net_income = @payslip.net_income
      expect(result_net_income).to eq(expect_net_income)
    end
  end # end Net income test

  describe "Super" do
    describe 'should be calculated by gross income multiply super rate' do
      it 'when result is rounded up' do
        @payslip = MonthlyPayslip.new(0, 9)
        @payslip.gross_income = 9022
        # 9022 * 0.09 = 811.98
        expect_super = 812

        result_super = @payslip.super_value
        expect(result_super).to eq(expect_super)
      end
      it 'when result is rounded down' do
        @payslip = MonthlyPayslip.new(0, 9)
        @payslip.gross_income = 5004
        # 5004 * 0.09 = 450.36 = 450
        expect_super = 450
        result_super = @payslip.super_value
        expect(result_super).to eq(expect_super)
      end
    end
  end # end Super test
end
