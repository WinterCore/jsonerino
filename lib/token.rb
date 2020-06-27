class Token
  TOKEN_ID           = :token_id
  TOKEN_STRING       = :token_string
  TOKEN_NUMBER       = :token_number
  TOKEN_LCURLY       = :token_lcurly
  TOKEN_RCURLY       = :token_rcurly
  TOKEN_LBRACKET     = :token_lbracket
  TOKEN_RBRACKET     = :token_rbracket
  TOKEN_COMMA        = :token_comma
  TOKEN_COLON        = :token_colon

  attr_reader :token, :value

  def initialize(token, value)
    @token = token
    @value = value
  end
end
