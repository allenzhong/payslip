$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lib/tax_rule'
require 'lib/monthly_payslip'
require 'lib/person'
require 'lib/payslip_generator'
require 'optparse'


if __FILE__ == $0
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: ruby payslip.rb [options]"
    # help
    opts.on('-h', '--help', 'Prints this help') do
      puts opts
      exit
    end

    opts.on('-i', '--input INPUT', 'Input CSV file name') { |v| options[:input] = v }
    opts.on('-o', '--output OUTPUT', 'Onput CSV file name') { |v| options[:output] = v }
  end.parse!

  if options[:input].nil?
    puts "Please provide input csv to continue..."
  end

  if options[:output].nil?
    puts "You don not provide output csv.\n It will automatically generated a CSV file named \"payslip.csv\":"
    loop do
      puts "Are you confirm or exit? [y/n]"
      confirm = gets.chomp
      case confirm
      when 'y' || 'Y'
        options[:output] = 'payslip.csv'
        break
      when 'n' || 'N'
        exit
      end
    end
  end

  begin
    payslip_generator = PayslipGenerator.new
    payslip_generator.read_file(options[:input])
    generated_file_name = payslip_generator.generate_file(options[:output])
    puts "The CSV file: #{generated_file_name} has been generated successfully"
  rescue Error => detail
    puts "There is an error when CSV file was being generated"
    puts detail
  end  
end
