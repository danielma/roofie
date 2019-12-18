Dir.glob(File.join(File.dirname(__FILE__), "visitors", "*")).each do |visitor|
  require visitor
end

module Roofie
  module Visitors
    DEBUG = !!ENV["DEBUG"]

    module_function

    def visit(node, formatter)
      check_node(node)

      visit_known_node(node, formatter, strict: false) || visit_unknown_node(node, formatter)
    rescue Roofie::RoofieError => e
      if !e.raised
        ap node
        e.raised = true
      end

      raise
    end

    def visit_known_node(node, formatter, strict: true)
      check_node(node)

      case node.first
      when :program
        visit_known_visitor(Roofie::Visitors::Program, node, formatter)
      when :assign
        visit_known_visitor(Roofie::Visitors::Assign, node, formatter)
      when :@int
        visit_known_visitor(Roofie::Visitors::IntLiteral, node, formatter)
      when :var_field
        visit_known_visitor(Roofie::Visitors::VarField, node, formatter)
      when :@ident
        visit_known_visitor(Roofie::Visitors::Ident, node, formatter)
      else
        if strict
          fail "you said you know this node! #{node}"
        end
      end
    end

    def visit_known_visitor(visitor, node, formatter)
      result = visitor.visit(node, formatter)

      if result.first == :visit
        visit(result[1], formatter)
      elsif result.first == :unknown
        visit_unknown_node(node, formatter)
      else
        result
      end
    end

    def visit_unknown_node(node, formatter)
      debug "Unknown node #{node}"

      output = []
      temporary_space_holder = []

      while formatter.tokens.current && (formatter.tokens.current_value != next_expected_token_value)
        if formatter.tokens.current_is_space?
          temporary_space_holder.push(formatter.tokens.consume_current)
        else
          output.concat(temporary_space_holder)
          temporary_space_holder = []
          output.push(formatter.tokens.consume_current)
        end
      end

      Roofie::DocBuilder.concat(output)
    end

    def debug(text)
      return if !DEBUG

      puts "DEBUG: #{text}"
    end

    def check_node(node)
      unless node.is_a?(Array)
        fail "expected array, but found #{node.ai}"
      end
    end
  end
end
