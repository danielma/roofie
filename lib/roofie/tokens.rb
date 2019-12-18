module Roofie
  class Tokens
    class WrongTypeError < Roofie::RoofieError; end

    def initialize(code)
      @tokens = Ripper.lex(code).reverse!
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

    def current_is_ignored_whitespace?
      current_is_space? || current_is_ignored_newline?
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
      current_type == :on_nl || current_is_ignored_newline?
    end

    def current_is_ignored_newline?
      current_type == :on_ignored_nl
    end

    def type(token)
      token ? token[1] : nil
    end
  end
end
