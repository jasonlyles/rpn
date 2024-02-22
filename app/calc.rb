# frozen_string_literal: true

require_relative './reverse_polish_notation_calculator'
require 'logger'

INVALID_INPUT_MESSAGE = 'Please make sure you only use integers, floats and the 4 basic arithmetic operators: + - * / and that your values are entered in correct Reverse Polish Notation order'

# Set up the logger
file = File.open('log/calculator.log', File::WRONLY | File::APPEND | File::CREAT)
# Without setting file.sync = true, the logger won't write to the log file while
# the calc process is still running.
file.sync = true
@logger = Logger.new(file, 10, 1_024_000)
@logger.level = Logger::INFO

bye = proc do
  puts "\nbye"
  exit
end

# Trap termination signals and call the 'bye' Proc to say bye and exit the program.
Signal.trap('INT',  &bye)
Signal.trap('TERM', &bye)

# Done with setting up, let's get on to the actual program.
@rpn_calculator = ReversePolishNotationCalculator.new

loop do
  print '> '
  input = gets.chomp
  # 'q' for quit, break the loop
  break if input == 'q'

  # Check to see that the characters are all valid. If not, print a message, and
  # let the user input again.
  if @rpn_calculator.input_valid?(input) == false
    puts INVALID_INPUT_MESSAGE
  else
    @rpn_calculator.handle_input(input)
    puts @rpn_calculator.current_value
  end
rescue ReversePolishNotationCalculator::InvalidInputOrder => e
  @logger.info("#{e} INVALID INPUT: [#{input}] CURRENT STACK: #{@rpn_calculator.stack.inspect}")
  puts 'Your input is not in valid Reverse Polish Notation order. Please see the docs on how to use this calculator.'
rescue ReversePolishNotationCalculator::InvalidInput => e
  @logger.info("#{e} INVALID INPUT: [#{input}] CURRENT STACK: #{@rpn_calculator.stack.inspect}")
  puts "Invalid character(s) #{INVALID_INPUT_MESSAGE}"
rescue StandardError => e
  # Handle any unexpected errors
  @logger.error("#{e} INPUT: [#{input}]\n#{e.backtrace.join("\n")}")
  puts "Something went wrong. #{INVALID_INPUT_MESSAGE}"
end

puts 'bye'
