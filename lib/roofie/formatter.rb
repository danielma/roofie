module Roofie
  class Formatter
    DEBUG = !!ENV["DEBUG"]
    B = Roofie::DocBuilder

    def initialize(code, options)
      @tokens = Tokens.new(code)
      @sexp = Ripper.sexp(code)
      @output = ""
      @options = options

      if !@sexp
        fail "syntax error"
      end
    end

    def format
      doc = visit @sexp

      Roofie::DocPrinter.print_doc_to_string(doc, print_width: @options.fetch(:print_width))[:formatted]
    end

    private

    attr_reader :tokens

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
      temporary_space_holder = []

      while tokens.current && (tokens.current_value != next_expected_token_value)
        if tokens.current_is_space?
          temporary_space_holder.push(tokens.consume_current)
        else
          output.concat(temporary_space_holder)
          temporary_space_holder = []
          output.push(tokens.consume_current)
        end
      end

      B.concat(output)
    end

    def visit_program(node)
      skip_space_or_newline

      lines = node[1].map.with_index do |child_node, index|
        @next_node = node[1][index + 1]

        doc = visit(child_node)

        if tokens.current_type == :on_nl
          B.concat([doc, B::HARD_LINE]).tap do
            tokens.move_to_next
          end
        else
          doc
        end
      end

      B.concat(lines)
    end

    def visit_assign(node)
      # [:assign, [:var_field, [:@ident, "x", [1, 0]]], [:@int, "2", [1, 4]]]

      visit_known_assign(node) || visit_unknown_node(node)
    end

    def visit_known_assign(node)
      return if node[1][0] != :var_field || node[2][0] != :@int

      skip_space
      identifier = tokens.consume_current
      skip_space
      tokens.consume_current(:on_op)
      skip_space

      value = tokens.consume_current

      skip_space

      B.group(
        B.concat(
          [identifier,
           " =",
           B.indent(
             B.concat(
               [B::LINE,
                value],
             ),
           )],
        ),
      )
    end

    def first_expected_token_value(node)
      unless node.is_a?(Array)
        fail "expected array, but found #{node.ai}"
      end

      case node.first
      when :program
        nil
      when :assign
        if node[1][0] == :var_field
          node[1][1][1]
        else
          nil
        end
      else
        nil
      end
    end

    def write(string)
      @output += string
    end

    def skip_space
      while tokens.current_is_space?
        tokens.move_to_next
      end
    end

    def skip_space_or_newline
      while tokens.current_is_space_or_newline?
        tokens.move_to_next
      end
    end

    def next_expected_token_value
      if @next_node
        first_expected_token_value(@next_node)
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
