require_relative './token.rb'

class Lexer
  SIMPLE_TOKENS_MATCHER = [
    ['{', Token::TOKEN_LCURLY],
    ['}', Token::TOKEN_RCURLY],
    ['[', Token::TOKEN_LBRACKET],
    [']', Token::TOKEN_RBRACKET],
    [':', Token::TOKEN_COLON],
    [',', Token::TOKEN_COMMA]
  ].freeze

  SIMPLE_ESCAPE_SEQUENCES_MATCHER = [
    ['"', '"'],
    ['b', "\b"],
    ['f', "\f"],
    ['r', "\r"],
    %W[n \n],
    %W[t \t]
  ].freeze

  attr_reader :i

  def initialize(contents)
    @contents = contents
    @i = 0
    @c = contents[@i]
  end

  def next_token
    skip_whitespace

    while more_content?

      # Numbers in JSON are only allowed to start with a minus sign
      return collect_number if numeric? || @c == '-'

      return collect_string if @c == '"'

      v = collect_simple_token
      return v if v

      raise "Unexpected character '#{@c}'"
    end
    nil
  end

  private

  def skip_whitespace
    advance while [' ', "\n", "\t"].include?(@c)
  end

  def advance
    return unless more_content?

    @i += 1
    c = @c
    @c = @contents[@i]
    c
  end

  def collect_simple_token
    token = Lexer::SIMPLE_TOKENS_MATCHER.find { |x| x[0] == @c }
    return nil unless token

    Token.new token[1], advance
  end

  def collect_string
    advance
    str = ''

    while @c != '"'
      str += @c == '\\' ? collect_escape_sequence : @c
      advance
    end
    advance

    Token.new(Token::TOKEN_STRING, str)
  end

  def collect_escape_sequence
    advance

    if (escape = Lexer::SIMPLE_ESCAPE_SEQUENCES_MATCHER.find { |x| x[0] == @c })
      escape[1]
    elsif @c == 'u'
      collect_unicode_escape
    else
      @c
    end
  end

  def collect_unicode_escape
    str_number = 4.times.inject('0x') do |str|
      advance
      raise "Invalid unicode escape sequence #{@c}" unless hex?

      str + @c
    end
    str_number.to_i.chr
  end

  def collect_number
    str_number = ''
    loop do
      str_number += @c
      advance
      break unless numeric? || ['.', '-', '+', 'e', 'E'].include?(@c)
    end
    Token.new(Token::TOKEN_NUMBER, str_number)
  end

  def more_content?
    @i < @contents.length
  end

  def numeric?
    !@c.match(/[0-9]/).nil?
  end

  def hex?
    !@c.match(/\h+/).nil?
  end
end
