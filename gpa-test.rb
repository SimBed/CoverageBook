GRADE_MAP = {
  'A' => 4.0, 'A-' => 3.7,
  'B+' => 3.3, 'B' => 3.0, 'B-' => 2.7,
  'C+' => 2.3, 'C' => 2.0, 'C-' => 1.7,
  'D+' => 1.3, 'D' => 1.0, 'D-' => 0.7,
  'E+' => 0.5, 'E' => 0.2, 'E-' => 0.1,
  'F' => 0.0,
  'U' => -1.0
}.freeze

# class to calculate students Grade Point Average
# Grades should be input as an array of strings
# Where the grades input are:
# -an array of symbols or numerical alternatives
# -a delimited string
# gpa will still be calculated, but with a warning advised
class Calculator
  attr_reader :name, :grades

  def initialize(name, grades)
    @name = name
    @grades = grades
    @error = false
    @warning = false
    @gpa = gpa
  end

  def gpa
    amend_grades_container unless @grades.instance_of?(Array)
    @error = true and return nil if @grades.nil? || @grades.empty?

    return nil unless all_grades_valid_class?

    amend_symbol_grades
    return nil unless all_grades_in_map_or_numeric?

    (grades_to_numbers.sum / courses_taken).round(1)
  end

  def announcement
    return 'error in input' if @error

    warning = ' (warning! non-standard input)' if @warning
    "#{name} scored an average of #{@gpa}#{warning}"
  end

  def self.numeric_grade?(grade)
    [Integer, Float].include? grade.class
  end

  private

  def grades_to_numbers
    @grades.map { |grade| self.class.numeric_grade?(grade) ? grade.to_f : GRADE_MAP[grade] }
  end

  def amend_grades_container
    if @grades.instance_of?(String)
      @warning = true
      @grades = @grades.split

    else
      @error = true
      @grades = nil
    end
  end

  def all_grades_valid_class?
    @grades.each do |grade|
      next if [String, Symbol, Integer, Float].any? { |klass| grade.instance_of? klass }

      @error = true
      return false
    end
    true
  end

  def amend_symbol_grades
    @grades = @grades.map do |grade|
      if grade.instance_of?(Symbol)
        @warning = true
        grade.to_s
      else
        grade
      end
    end
  end

  def all_grades_in_map_or_numeric?
    @grades.each do |grade|
      next if GRADE_MAP.keys.include? grade

      unless self.class.numeric_grade?(grade)
        @error = true
        return false
      end
      @warning = true
    end
    true
  end

  def courses_taken
    grades.size
  end
end

## Do not edit below here ##################################################

# corrected tests (Emma, Frida, Gary's names and Frida's gpa)
tests = [
  { in: { name: 'Andy', grades: ['A'] }, out: { gpa: 4, announcement: 'Andy scored an average of 4.0' } },
  { in: { name: 'Beryl',  grades: ['A', 'B', 'C'] }, out: { gpa: 3, announcement: 'Beryl scored an average of 3.0' } },
  { in: { name: 'Chris',  grades: ['B-', 'C+'] }, out: { gpa: 2.5, announcement: 'Chris scored an average of 2.5' } },
  { in: { name: 'Dan', grades: ['A', 'A-', 'B-'] }, out: { gpa: 3.5, announcement: 'Dan scored an average of 3.5' } },
  { in: { name: 'Emma', grades: ['A', 'B+', 'F'] }, out: { gpa: 2.4, announcement: 'Emma scored an average of 2.4' } },
  { in: { name: 'Frida', grades: ['E', 'E-'] }, out: { gpa: 0.2, announcement: 'Frida scored an average of 0.2' } },
  { in: { name: 'Gary', grades: ['U', 'U', 'B+'] }, out: { gpa: 0.4, announcement: 'Gary scored an average of 0.4' } }
]

extra_tests1 = [
  { in: { name: 'Non-grades', grades: ['N'] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Non-strings', grades: ['A', :B] }, out: { gpa: 3.5, announcement: 'Non-strings scored an average of 3.5 (warning! non-standard input)' } },
  { in: { name: 'Empty', grades: [] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Numbers', grades: [1, 2] }, out: { gpa: 1.5, announcement: 'Numbers scored an average of 1.5 (warning! non-standard input)' } },
  { in: { name: 'Passed a string', grades: 'A A-' }, out: { gpa: 3.9, announcement: 'Passed a string scored an average of 3.9 (warning! non-standard input)' } }
]

extra_tests2 = [
  { in: { name: 'Hash', grades: { A: 1, B: 2 } }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'String & Boolean', grades: ['A', true] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Full of Empties', grades: [[], []] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Floats', grades: [1.23, 2.57] }, out: { gpa: 1.9, announcement: 'Floats scored an average of 1.9 (warning! non-standard input)' } },
  { in: { name: 'nil', grades: nil }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'String Number', grades: ['A', 4.0] }, out: { gpa: 4.0, announcement: 'String Number scored an average of 4.0 (warning! non-standard input)' } }
]

tests += extra_tests1
tests += extra_tests2

tests.each do |test|
  user = Calculator.new(test[:in][:name], test[:in][:grades])

  puts "#{'-' * 10} #{user.name} #{'-' * 10}"

  [:gpa, :announcement].each do |method|
    result = user.public_send(method)
    expected = test[:out][method]

    if result == expected
      puts "✅ #{method.to_s.upcase}: #{result}"
    else
      puts "❌ #{method.to_s.upcase}: expected '#{expected}' but got '#{result}'"
    end
  end

  puts
end
