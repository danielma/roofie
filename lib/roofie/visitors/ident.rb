module Roofie
  module Visitors
    module Ident
      module_function

      def visit(node, formatter)
        # [:@ident, "z", [6, 2]]

        Roofie::DocBuilder.concat([formatter.consume_current_token(:on_ident)])
      end
    end
  end
end
