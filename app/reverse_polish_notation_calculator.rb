# frozen_string_literal: true

class ReversePolishNotationCalculator
  class InvalidInput < StandardError; end
  class InvalidInputOrder < StandardError; end

  SUPPORTED_OPERATORS = %w[+ - * /].freeze

  attr_reader :stack

  def initialize
    @stack = []
  end

  # This doesn't check to make sure that the input works with what's already on the
  # stack, it only confirms that the input could be valid by checking the characters
  # to make sure they're numeric or one of the supported operators, and that they're
  # in the correct order, with numbers preceding operators.
  def input_valid?(input)
    # First, check a regex to make sure the input is in the desired format. Regex
    # developed here: https://rubular.com/r/l5pNVfBhWAoIOD (Not sure how long this url will be valid)
    return false unless input.match(/^(-?\d+(\.\d+)*\s*)*([\+\-\*\/]*\s*)*$/)

    # As a secondary check, loop through the input to make sure each element is valid.
    input.split.each do |value|
      next if supported_operator?(value)
      next if numeric?(value)

      # If the value is not a supported operator and is not numeric, then it's
      # invalid, and the whole input is invalid.
      return false
    end

    # If we make it this far, then the characters passed in are valid.
    true
  end

  # This method takes care of pushing and popping numbers on/off the stack and
  # calling the passed-in operators to calculate values.
  def handle_input(input)
    input.split.each do |value|
      if supported_operator?(value)
        # If we have an operator, we need to get the last 2 numbers in the stack
        # and perform the arithmetic with the operator to get the current value.
        numbers = @stack.pop(2)
        if numeric?(numbers[0]) && numeric?(numbers[1])
          result = numbers[0].send(value.to_sym, numbers[1])

          # Now store the result
          @stack.push(result)
        else
          # In case someone is not using the calculator correctly, we'll need to push
          # the values back on to the stack so once the user corrects their usage,
          # the value will be available for the next operation.
          #
          # We're popping off the stack vs checking values and then popping off
          # the stack because we should encounter the happy path most of the time,
          # and we only need to perform an extra operation on the stack if the user
          # made a mistake.
          numbers.compact.each { |number| @stack.push(number) }

          raise ReversePolishNotationCalculator::InvalidInputOrder
        end
      elsif numeric?(value)
        # All numbers get pushed to the stack to await being popped off when an
        # operator gets passed in.
        @stack.push(value.to_f)
      else
        # We should never make it here, because invalid characters should be caught
        # before we get to this method. Just in case...
        raise ReversePolishNotationCalculator::InvalidInput
      end
    end
  end

  def current_value
    @stack.last
  end

  private

  def supported_operator?(value)
    SUPPORTED_OPERATORS.include?(value)
  end

  def numeric?(value)
    # If the string value can be cast as a float, then the value is "numeric"
    Float(value, exception: false) ? true : false
  end
end
