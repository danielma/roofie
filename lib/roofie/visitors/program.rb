module Roofie
  module Visitors
    module Program
      module_function

      def visit(node, formatter)
        formatter.skip_ignored_whitespace

        lines = node[1].map.with_index do |child_node, index|
          @next_nodes = node[1][(index + 1)..-1]

          doc = Roofie::Visitors.visit(child_node, formatter)

          if formatter.current_token_type == :on_nl
            Roofie::DocBuilder.concat([doc, Roofie::DocBuilder::HARD_LINE]).tap do
              formatter.move_to_next_token
            end
          else
            doc
          end
        end

        Roofie::DocBuilder.concat(lines)
      end
    end
  end
end
