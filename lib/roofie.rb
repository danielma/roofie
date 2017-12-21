require "roofie/version"
require "ripper"
require "awesome_print"

module Roofie
  module_function

  def format(code)
    Formatter.new(code).format
  end

  class Formatter
    def initialize(code)
      @tokens = Ripper.lex(code).reverse!
      @sexp = Ripper.sexp(code)
      @output = ""

      if !@sexp
        fail "syntax error"
      end
    end

    def format
      visit @sexp

      @output
    end

    private
    
    def visit(node)
      unless node.is_a?(Array)
        fail "expected array, but found #{node.ai}"
      end

      case node.first
      when :program
        node[1].each.with_index do |child_node, index|
          @next_node = node[1][index + 1]

          visit(child_node)
        end
      else
        visit_unknown_node(node)
      end
    end

    def visit_unknown_node(node)
      while current_token_value != next_expected_token_value
        @output += current_token_value
        move_to_next_token
      end
    end

    def first_expected_token(node)
      unless node.is_a?(Array)
        fail "expected array, but found #{node.ai}"
      end

      case node.first
      when :program
        nil
      else
        nil
      end
    end

    def move_to_next_token
      @tokens.pop
    end

    def current_token
      @tokens.last
    end

    def current_token_value
      token_value(current_token)
    end

    def token_value(token)
      token ? token[2] : ""
    end

    def next_expected_token_value
      if @next_node
        token_value(first_expected_token(@next_node))
      else
        ""
      end
    end
  end
end
