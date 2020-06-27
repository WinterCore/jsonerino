require_relative './token.rb'

class Lexer
  attr_reader :i

  def initialize(contents)
    @contents = contents
    @i        = 0
    @c        = contents[@i]
  end


  def advance_with_token(token)
    advance
    token
  end

  def advance
    if has_more_content
      @i += 1
      @c = @contents[@i]
    end
  end
end
