module Roofie
  class Tokens
    def initialize(code)
      @tokens = Ripper.lex(code).reverse!
    end

    def assert_current_type(type)
      return if current_type == type

      fail "wrong type. expected #{type} got #{current_type} #{current.inspect}"
    end

    def consume_current(expected_type = nil)
      assert_current_type(expected_type) if expected_type

      current_value.tap do
        move_to_next
      end
    end

    def move_to_next
      tokens.pop
    end

    def current
      tokens.last
    end

    def current_value
      value(current)
    end

    def current_type
      type(current)
    end

    def current_is_space_or_newline?
      current_is_space? || current_is_newline?
    end

    def current_is_space?
      current_type == :on_sp
    end

    def value(token)
      token && token[2]
    end

    private

    attr_reader :tokens

    def current_is_newline?
      current_type == :on_nl || current_type == :on_ignored_nl
    end

    def type(token)
      token ? token[1] : nil
    end
  end
end
