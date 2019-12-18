module Roofie
  module Visitors
    module VarField
      module_function

      def visit(node, tokens)
        # [:var_field, [:@ident, "x", [2, 0]]]

        [:visit, node[1]]
      end
    end
  end
end
