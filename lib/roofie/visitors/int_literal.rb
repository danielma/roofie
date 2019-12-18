module Roofie
  module Visitors
    module IntLiteral
      module_function

      def visit(node, tokens)
        # [:@int, "10", [6, 8]]

        Roofie::DocBuilder.concat([tokens.consume_current(:on_int)])
      end
    end
  end
end
