require "roofie/version"
require "roofie/formatter"
require "ripper"
require "awesome_print"

module Roofie
  def self.format(code)
    Formatter.new(code).format
  end
end
