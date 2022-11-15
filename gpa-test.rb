# class to calculate students' Grade Point Averages
# Input requirements are strict. Grades must be input as an array of strings
class Calculator
  attr_reader :name, :grades

  def initialize(name, grades)
    @name = name
    @grades = grades
    @gpa = gpa
  end

  def gpa
    (grades_to_numbers.sum / courses_taken).round(1)
  rescue TypeError, ZeroDivisionError, NoMethodError
    nil
  end

  def announcement
    return 'error in input' if @gpa.nil?

    "#{name} scored an average of #{@gpa}"
  end

  private

  def grades_to_numbers
    grade_map = {
      'A' => 4.0, 'A-' => 3.7,
      'B+' => 3.3, 'B' => 3.0, 'B-' => 2.7,
      'C+' => 2.3, 'C' => 2.0, 'C-' => 1.7,
      'D+' => 1.3, 'D' => 1.0, 'D-' => 0.7,
      'E+' => 0.5, 'E' => 0.2, 'E-' => 0.1,
      'F' => 0.0,
      'U' => -1.0
    }
    grades.map { |grade| grade_map[grade] }
  end

  def courses_taken
    grades.size
  end
end

## Do not edit below here ##################################################

# corrected tests (Emma, Frida, Gary's names and Frida's gpa)
tests = [
  { in: { name: 'Andy',  grades: ["A"] }, out: { gpa: 4, announcement: "Andy scored an average of 4.0"  } },
  { in: { name: 'Beryl',  grades: ["A", "B", "C"] }, out: { gpa: 3, announcement: "Beryl scored an average of 3.0"  } },
  { in: { name: 'Chris',  grades: ["B-", "C+"] }, out: { gpa: 2.5, announcement: "Chris scored an average of 2.5"  } },
  { in: { name: 'Dan',  grades: ["A", "A-", "B-"] }, out: { gpa: 3.5, announcement: "Dan scored an average of 3.5"  } },
  { in: { name: 'Emma',  grades: ["A", "B+", "F"] }, out: { gpa: 2.4, announcement: "Emma scored an average of 2.4"  } },
  { in: { name: 'Frida',  grades: ["E", "E-"] }, out: { gpa: 0.2, announcement: "Frida scored an average of 0.2"  } },
  { in: { name: 'Gary',  grades: ["U", "U", "B+"] }, out: { gpa: 0.4, announcement: "Gary scored an average of 0.4"  } },
]

# how_might_you_do_these = [
#   { in: { name: 'Non-grades',  grades: ["N"] } },
#   { in: { name: 'Non-strings',  grades: ["A", :B] } },
#   { in: { name: 'Empty',  grades: [] } },
#   { in: { name: 'Numbers',  grades: [1, 2] } },
#   { in: { name: 'Passed a string',  grades: "A A-" } },
# ]

extra_tests = [
  { in: { name: 'Non-grades',  grades: ['N'] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Non-strings',  grades: ['A', :B] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Empty',  grades: [] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Numbers',  grades: [1, 2] }, out: { gpa: nil, announcement: 'error in input' } },
  { in: { name: 'Passed a string',  grades: 'A A-' }, out: { gpa: nil, announcement: 'error in input' } }
]

tests += extra_tests

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
