require_relative './token'
require_relative './ast'
require_relative './helpers'

class Parser
  def initialize(lexer)
    @lexer = lexer
    @current_token = lexer.next_token
  end

  def consume(token)
    raise "Unexpected token '#{@current_token.value}'" if token != @current_token.token

    value = @current_token.value
    @current_token = @lexer.next_token
    value
  end

  def parse
    # handle empty strings
    case @current_token.token
    when Token::TOKEN_LBRACKET
      parse_array
    when Token::TOKEN_LCURLY
      parse_object
    when Token::TOKEN_STRING
      JsonString.new consume(Token::TOKEN_STRING)
    when Token::TOKEN_NUMBER
      JsonNumber.new consume(Token::TOKEN_NUMBER)
    when Token::TOKEN_ID
      parse_id
    else
      unexpected_token
    end
  end

  def unexpected_token
    raise "Unexpected token #{@current_token.value}"
  end

  def parse_object
    consume Token::TOKEN_LCURLY
    obj = JsonObject.new
    if @current_token != Token::TOKEN_RCURLY
      loop do
        key = consume(Token::TOKEN_STRING)
        consume(Token::TOKEN_COLON)
        value = parse
        obj.push key, value
        break if @current_token.token != Token::TOKEN_COMMA

        consume(Token::TOKEN_COMMA)
      end
    end
    consume Token::TOKEN_RCURLY
    obj
  end

  def parse_array
    consume Token::TOKEN_LBRACKET
    arr = JsonArray.new
    if @current_token != Token::TOKEN_RBRACKET
      loop do
        arr.push parse
        break if @current_token.token != Token::TOKEN_COMMA

        consume(Token::TOKEN_COMMA)
      end
    end
    consume Token::TOKEN_RBRACKET
    arr
  end

  def parse_id
    case consume(Token::TOKEN_ID)
    when 'true'
      JsonBool.new true
    when 'false'
      JsonBool.new false
    when 'null'
      JsonNull.new
    else
      unexpected_token
    end
  end
end
