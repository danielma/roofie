module Roofie
  class Formatter
    DEBUG = !!ENV["DEBUG"]
    B = Roofie::DocBuilder

    def initialize(code)
      @tokens = Ripper.lex(code).reverse!
      @sexp = Ripper.sexp(code)
      @output = ""

      if !@sexp
        fail "syntax error"
      end
    end

    def format
      doc = visit @sexp

      Roofie::DocPrinter.print_doc_to_string(doc, print_width: 80)[:formatted]
    end

    private

    def visit(node)
      unless node.is_a?(Array)
        fail "expected array, but found #{node.ai}"
      end

      case node.first
      when :program
        visit_program(node)
      when :assign
        visit_assign(node)
      else
        visit_unknown_node(node)
      end
    end

    def visit_unknown_node(node)
      debug "Unknown node #{node}"

      output = []

      while current_token_value != next_expected_token_value
        output.push(consume_current_token)
      end

      B.concat(output)
    end

    def visit_program(node)
      skip_space_or_newline

      lines = node[1].map.with_index do |child_node, index|
        @next_node = node[1][index + 1]

        doc = visit(child_node)

        if current_token_type == :on_nl
          B.concat([doc, B::HARD_LINE]).tap do
            move_to_next_token
          end
        else
          doc
        end
      end

      B.concat(lines)
    end

    def visit_assign(node)
      # [:assign, [:var_field, [:@ident, "x", [1, 0]]], [:@int, "2", [1, 4]]]

      skip_space
      identifier = consume_current_token
      skip_space
      consume_current_token(:on_op)
      skip_space

      value = consume_current_token

      skip_space

      B.concat([identifier, " = ", value])
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

    def write(string)
      @output += string
    end

    def skip_space
      while current_token_type == :on_sp
        move_to_next_token
      end
    end

    def skip_space_or_newline
      while current_token_type == :on_sp || current_token_type == :on_nl || current_token_type == :on_ignored_nl
        move_to_next_token
      end
    end

    def assert_current_token_type(type)
      return if current_token_type == type

      fail "wrong type. expected #{type} got #{current_token_type} #{current_token_value.inspect}"
    end

    def consume_current_token(type = nil)
      assert_current_token_type(type) if type

      current_token_value.tap do
        move_to_next_token
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

    def current_token_type
      token_type(current_token)
    end

    def token_value(token)
      token ? token[2] : ""
    end

    def token_type(token)
      token ? token[1] : nil
    end

    def next_expected_token_value
      if @next_node
        token_value(first_expected_token(@next_node))
      else
        ""
      end
    end

    def debug(text)
      return if !DEBUG

      puts "DEBUG: #{text}"
    end
  end
end
