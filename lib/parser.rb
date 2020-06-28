require_relative './token'
require_relative './ast'
require_relative './helpers'
require_relative './parse_error'

class Parser
  def initialize(lexer)
    @lexer = lexer
    @current_token = lexer.next_token
  end

  def parse
    raise_end_of_data unless @current_token

    v = parse_json_value
    raise_unexpected_token unless v
    v
  end

  def parse_json_value
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
    end
  end

  private

  def consume(token)
    if @current_token.nil?
      raise_end_of_data
    elsif token != @current_token.token
      raise_unexpected_token
    end

    value = @current_token.value
    @current_token = @lexer.next_token
    value
  end

  def raise_unexpected_token
    message = "Unexpected token '#{@current_token.value}'"\
              " at line #{@current_token.line} column #{@current_token.start} of the JSON data"
    raise JsonParseError.new, message
  end

  def raise_end_of_data
    raise JsonParseError.new, 'End of data while reading object contents of the JSON data'
  end

  def parse_object
    consume Token::TOKEN_LCURLY
    obj = JsonObject.new
    if @current_token && @current_token.token != Token::TOKEN_RCURLY
      loop do
        key = consume(Token::TOKEN_STRING)
        consume(Token::TOKEN_COLON)
        value = parse
        obj.push key, value
        break if @current_token && @current_token.token != Token::TOKEN_COMMA

        consume(Token::TOKEN_COMMA)
      end
    end
    consume Token::TOKEN_RCURLY
    obj
  end

  def parse_array
    consume Token::TOKEN_LBRACKET
    arr = JsonArray.new
    if @current_token && @current_token.token != Token::TOKEN_RBRACKET
      loop do
        arr.push parse
        break if @current_token && @current_token.token != Token::TOKEN_COMMA

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
      raise_unexpected_token
    end
  end
end
