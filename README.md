Solution
=========

**Assumptions**
1. Imaging there is a console application in which application will be able to read the existing CSV file by its path after user type command in terminal. It consists of comma-separated values accordance with columns required in MYOB documents.

2. When user execute the main application, by passing a CSV file path as a parameter, application will handle the further process.

3. After finished all things, the application should give a notification/result to inform user whether the output/CSV file is generated successfully or not. And the path of the file should be displayed if successful. Otherwise, some errors should be given either.

**Collecting Thoughts**
1. Starting from document that providing input and output, the first test should be written for these. Input the certain columns and output the certain string which could generate CSV file. It's like a black-box test.
2. Along side this way, this task sould be break down from top into several tests. Having a look at each item in output columns, each one should be hanled in different methods and return proper values that could build the final results.
3. Assuming a person has many payslips, each one is only for a month. Person has name, annual salay, different super rate and many payslips.

**Class and Resiponsiblity**
1. `PayslipGenerator`: Resiponsible for read and write files
2. `Person`: who has multiple monthly payslips. Each line of CSV represents a person's payslip in a certain month.
3. `Monthly Payslip`: A payslip belongs to a person in a certain month

**Explaination of Class Design**
1. A `Person` who has many `Payslip`, which is an array in `Person`'s instance
2. Attributes in `Payslip` are calculated based on passed parameters `annual_salary` and `super rate` of `Person`.
3. `PayslipGenerator` could read data from CSV and process data into `Person`. Finally, it writes data into new files, regarding to the attributes that can be calculated in `Person`.

**Payslip Generator**
1. Considering the input is a CSV file, it should be read line by line and converted to a person array. For each person, the object which consists of columns.
2. Iterator this array and calculate it, save it to a new array in order to generate a final CSV file.
3. Iterator new array and write person's inform to final CSV file line by line.

**Payslip Person Design**
1. For each person, it consists of those read/write attributes: `first_name`, `last_name`, `annualy_salary`, `super_rate`. Those are inputs from each line in CSV.

2. Looking at **name**, when **first name** and **last name** are provided, the final output is only a name in format `FirstName LastName`.
3. Then for `pay period`, it directly copy the same string to output from `payment start date`.

**Payslip**
1.  there are 4 attributes which should be calculated based on Person's attributes: `annual_salary` and `super rate`. They are `gross_time`, `income_tax`, `net_income`, `super_value`. Other attributes are `pay_period`.
2.  For `gross_time`, `income_tax`, `net_income` and `super_value`, because of their complexity, their logics should be extracted into the specific class(Payslip) in which logic can be decoupled and extended later when needed. And in fact, those attributes are not the attributes of a person. Setting them as writers is just for convenience of testing. 
3. When it comes to `gross income`, the formula is `gross income = annual salary / 12`, but the result should be round up or down(depends on if fraction part greater than and equal 50 or not). 
4. Income tax is much more complex than others. There is a rules as following:
    Taxable income and Tax on this income 
    * `0` to `$18,200` 
      * Nil
    * `$18,201` - `$37,000` 
      * `19c` for each `$1` over `$18,200`
    * `$37,001` - `$80,000` 
      * `$3,572` plus `32.5c` for each `$1` over `$37,000` 
    * `$80,001` - `$180,000` 
      * `$17,547` plus `37c` for each `$1` over `$80,000` 
    * `$180,001` and over  
      * `$54,547` plus `45c` for each `$1` over `$180,000`
 
    **Here should be designed as different methods for each tax level.** In this way, each rule can be tested respectively.

5. To calculate `net income`, the parameters needed are only `gross income` and `income tax`, which two has been calculated by previous part. Just design it as a function with two parameters.
5. Likewise, to get `super`, only two of parameters, which are `gross income` and `super rate`, pass into the function and return value of `super`.
6. Each test should be depended on others. It should be independent as same as testing method's single resonsibility.

**Refactor for Tax Rules**
1. After implemented functionality, one thing should be solved is refactoring the place with highly coupling.
2. The first place should be tax rules. Because tax could be changed in the future, application should adapt new tax policy. 
3. To implement this way, one of choice is strategy pattern. Creating an abtract and top class as abstract tax rule/policy, its descendants should have the same method that can be invoked as the same type invoked.
4. Each monthly paylisp should have a tax rules that is passed by its caller. Configuration from outside of application also can be considered. 

**Final Classes**
1. `PayslipGenerator`: Resiponsible for read and write files
2. `Person`: who has multiple monthly payslips. Each line of CSV represents a person's payslip in a certain month. Considering if the person and its payslip are saved as different table in database, which is very common, having a person's id or name could find his/her payslip in other table. This is why person has multiple payslips. But in this situation, with the limitation of input from csv, here might be a little bit over-designed.
3. `Monthly Payslip`: A payslip belongs to a person in a certain month
4. `CurrentTaxRule` and `TaxRule`: Those are decoupled logic as mentioned in previous section.

**File structures**
1. `lib`: Source code 
2. `spec`: All test code with suffix `spec`
3. `.rspec`: He is saying "Don't remove me"
4. `Gemfile`: The way of managing packages being used in this application
5. `Gemfile.lock`: Lock the version of packages
6. `payslip.rb`: Main Entry
7. `README.md`: It is me! It is me!
8. `example.csv`: It's your guys provided. Thanks though it is short.

Installation
=============
**Installation**

1. Please ensure the environment is set up correctly.
    * System: Any System could install Ruby 
    * Ruby: 2.4.1 (at leat 2.2.0+)
    * Bundler: 1.15.1
    * Gem: 2.6.11
2. For Ruby installation, please visit [this website](https://www.ruby-lang.org/en/documentation/installation/).
3. It is better to use [RVM](https://rvm.io/) for Ruby installation.

**Preparation**

1. After installation, in terminal, type following command.
    
    ```Bash
      bundle install
    ```
    
2. Then run test

    ```Bash
      rspec
    ```
    
3. If test will be passed, go to next section. Otherwise, check environment


**Execution Application**
1. Prepare your CSV file, there is a example (`example.csv`) for test. If you want to try more, please use following format as a example:
 
    * **Format** `first name, last name, annual salary, super rate (%), payment start date`
    

2. To use this console application, here is instruction
    ```bash
    ruby payslip.rb -h
      Usage: ruby payslip.rb [options]
      -h, --help                       Prints this help
      -i, --input INPUT                Input CSV file name
      -o, --output OUTPUT              Onput CSV file name
    ```
    
    By providing `-o` or `--output` arguments, the output file will be specified.
    ```bash
    ruby payslip.rb -i example.csv -o payslip.csv
    ```
    
    By ignoring `-o` or `--output` arguments, application will generated file with default name `payslip.csv`
    
    ```bash
    ruby payslip.rb -i example.csv
      You don not provide output csv.
      It will automatically generated a CSV file named `payslip.csv`:
      Are you confirm or exit? [y/n]
    ```
3. Enjoy! Please feel free to ask me questions. 

