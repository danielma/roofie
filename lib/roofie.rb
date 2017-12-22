require "roofie/version"
require "ripper"
require "awesome_print"
require "roofie/tokens"
require "roofie/doc_builder"
require "roofie/doc_printer"
require "roofie/formatter"

module Roofie
  def self.format(code)
    Formatter.new(code).format
  end
end
