require "roofie/version"
require "ripper"
require "awesome_print"
require "roofie/errors"
require "roofie/tokens"
require "roofie/doc_builder"
require "roofie/visitors"
require "roofie/doc_printer"
require "roofie/formatter"

module Roofie
  DEFAULT_OPTIONS = { print_width: 80 }.freeze

  def self.format(code, options = {})
    Formatter.new(DEFAULT_OPTIONS.merge(options)).format(code)
  end
end
