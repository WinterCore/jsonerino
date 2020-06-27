require_relative './token.rb'

class Lexer
  attr_reader :i

  def initialize(contents)
    @contents = contents
    @i        = 0
    @c        = contents[@i]
  end

  def get_next_token
    while has_more_content
      if @c == ' ' || @c == "\n" || @c == "\t"  # skip whitespace
        advance
        next
      end


      v = case @c
          when '{'
            advance_with_token(Token.new(Token::TOKEN_LCURLY, @c))
          when '}'
            advance_with_token(Token.new(Token::TOKEN_RCURLY, @c))
          when '['
            advance_with_token(Token.new(Token::TOKEN_LBRACKET, @c))
          when ']'
            advance_with_token(Token.new(Token::TOKEN_RBRACKET, @c))
          when ':'
            advance_with_token(Token.new(Token::TOKEN_COLON, @c))
          when ','
            advance_with_token(Token.new(Token::TOKEN_COMMA, @c))
          when "'", '"'
            collect_string
          end
      return v if v
      raise "Unexpected character '#{@c}'"
    end
    nil
  end

  private

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

  def collect_string
    advance
    str = ''

    while @c != '"'
      str += if @c == "\\" then collect_escape_sequence else @c end
      advance
    end
    advance

    Token.new(Token::TOKEN_STRING, str)
  end

  def collect_escape_sequence
    advance
    case @c
    when '"'
      "\""
    when 'n'
      "\n"
    when 'b'
      "\b"
    when 'f'
      "\f"
    when 'r'
      "\r"
    when 't'
      "\t"
    when 'u'
      collect_unicode_escape
    else
      @c
    end
  end

  def collect_unicode_escape
    str_number = 4.times.inject('0x') do |str|
      advance
      raise "Invalid unicode escape sequence #{@c}" unless is_hex
      str += @c
      str
    end
    str_number.to_i.chr
  end

  def collect_number
    str_number = ''
    begin
      str_number += @c
      advance
    end while is_numeric || ['.', '-', '+', 'e', 'E'].include?(@c)
    Token.new(Token::TOKEN_NUMBER, str_number)
  end

  def has_more_content
    @i < @contents.length
  end

  def is_hex
    !@c.match(/\h+/).nil?
  end
end
