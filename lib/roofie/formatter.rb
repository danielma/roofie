module Roofie
  class Formatter
    def initialize(options)
      @options = options
    end

    def format(code)
      @tokens = Tokens.new(code)
      sexp = Ripper.sexp(code)

      if !sexp
        fail "syntax error"
      end

      doc = Roofie::Visitors.visit(sexp, self)

      Roofie::DocPrinter.print_doc_to_string(doc, print_width: @options.fetch(:print_width))[:formatted]
    end

    def skip_ignored_whitespace
      while @tokens.current_is_ignored_whitespace?
        @tokens.move_to_next
      end
    end

    def consume_current_token(expected_type = nil)
      assert_current_token_type(expected_type) if expected_type

      current_value.tap do
        move_to_next
      end
    end

    def assert_current_token_type(type)
      return if current_token_type == type

      fail WrongTypeError, "expected #{type} got #{current_token_type} #{current_token.inspect}"
    end

    private

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

    def next_expected_token_value
      if @next_nodes
        @next_nodes.each do |node|
          value = first_expected_token_value(node)

          return value if value
        end
      else
        ""
      end
    end
  end
end
