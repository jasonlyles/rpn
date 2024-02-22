# frozen_string_literal: true

require_relative '../../app/reverse_polish_notation_calculator'

RSpec.describe ReversePolishNotationCalculator do
  describe 'input_valid?' do
    context 'all values passed in are valid' do
      it 'should return true' do
        rpn_calculator = ReversePolishNotationCalculator.new

        valid_inputs = [
          '1 1 +',
          '5 5 5 8 + + -',
          '3',
          '3.25',
          '-3',
          '-45.45',
          '3.25 +',
          '-3.24 -',
          '*',
          '/',
          '- + -',
          '5 5 5'
        ]

        valid_inputs.each do |input|
          result = rpn_calculator.input_valid?(input)
          expect(result).to eq(true), "input_valid? failed to return true for '#{input}'"
        end
      end
    end

    context 'at least one value passed in is invalid' do
      it 'should return false' do
        rpn_calculator = ReversePolishNotationCalculator.new

        invalid_inputs = [
          '1 1 + 1',
          '5 5 5 8 + + - - 3',
          '- 3',
          '3.25 bad',
          '- -3',
          '--',
          '+ -45.45',
          '+ 3.25 +',
          '- -3.24 -',
          '%',
          '- + 3 -',
          '5 - 5 5',
          '8 + 8'
        ]

        invalid_inputs.each do |input|
          result = rpn_calculator.input_valid?(input)
          expect(result).to eq(false), "input_valid? failed to return false for '#{input}'"
        end
      end
    end
  end

  describe 'handle_input' do
    context 'happy path' do
      it 'should receive input and do the correct calculations' do
        # Happy path test case 1
        rpn_calculator = ReversePolishNotationCalculator.new
        rpn_calculator.handle_input('5 5 5 8 + + -')
        rpn_calculator.handle_input('13 +')
        expect(rpn_calculator.stack).to eq([0.0])

        # Happy path test case 2
        rpn_calculator = ReversePolishNotationCalculator.new
        rpn_calculator.handle_input('5')
        rpn_calculator.handle_input('8')
        rpn_calculator.handle_input('+')
        expect(rpn_calculator.stack).to eq([13.0])

        # Happy path test case 3
        rpn_calculator = ReversePolishNotationCalculator.new
        rpn_calculator.handle_input('-3')
        rpn_calculator.handle_input('-2')
        rpn_calculator.handle_input('*')
        rpn_calculator.handle_input('5')
        rpn_calculator.handle_input('+')
        expect(rpn_calculator.stack).to eq([11.0])

        # Happy path test case 4
        rpn_calculator = ReversePolishNotationCalculator.new
        rpn_calculator.handle_input('5')
        rpn_calculator.handle_input('9')
        rpn_calculator.handle_input('1')
        rpn_calculator.handle_input('-')
        rpn_calculator.handle_input('/')
        expect(rpn_calculator.stack).to eq([0.625])
      end
    end

    context 'An invalid value got through somehow' do
      it 'should raise an error' do
        rpn_calculator = ReversePolishNotationCalculator.new
        expect { rpn_calculator.handle_input('bad') }.to raise_error(ReversePolishNotationCalculator::InvalidInput)
      end
    end
  end
end
