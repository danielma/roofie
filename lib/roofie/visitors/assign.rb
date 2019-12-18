module Roofie
  module Visitors
    module Assign
      module_function

      B = Roofie::DocBuilder

      def visit(node, tokens)
        # [:assign, [:var_field, [:@ident, "x", [1, 0]]], [:@int, "2", [1, 4]]]

        visit_known_assign(node, tokens) || [:unknown, node]
      end

      private def visit_known_assign(node, tokens)
        return if node[1][0] != :var_field
        return if !%i(@int symbol_literal).include?(node[2][0])

        tokens.skip_ignored_whitespace

        identifier = Roofie::Visitors.visit_known_node(node[1], tokens)

        tokens.skip_ignored_whitespace

        tokens.consume_current(:on_op)

        tokens.skip_ignored_whitespace

        value = Roofie::Visitors.visit_known_node(node[2], tokens)

        tokens.skip_ignored_whitespace

        B.group(
          B.concat(
            [
              identifier,
              " =",
              B.indent(
                B.concat([B::LINE, value]),
              ),
            ],
          ),
        )
      end
    end
  end
end
