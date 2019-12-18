module Roofie
  class RoofieError < StandardError
    attr_writer :raised

    def raised
      return @raised if defined?(@raised)

      @raised = false
    end
  end
end
