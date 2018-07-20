require 'sh_vars/string'

module ShVars
  extend self

  ArgumentError = Class.new(::ArgumentError)
  ParseError    = Class.new(ArgumentError)

  def parse(obj)
    String.new(obj).parse
  end
end
