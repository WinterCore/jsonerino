require 'jsonerino/parser'
require 'jsonerino/lexer'

module Jsonerino
  def self.parse(str)
    lexer = Jsonerino::Lexer.new str
    parser = Jsonerino::Parser.new lexer
    parser.parse.resolve
  end
end
