require_relative '../../lib/jsonerino'
require_relative '../../lib/jsonerino/parse_error'

describe Jsonerino do
  describe '#parse (exceptions)' do
    it 'Should throw parse error when invoked on empty strings' do
      expect { Jsonerino.parse('  ') }.to raise_error(Jsonerino::JsonParseError)
    end

    it 'Should print out the line (row) and character index (column) to indicate where the parse error occurred' do
      expect { Jsonerino.parse('{"foo" }') }.to raise_error(Jsonerino::JsonParseError, /line 1 column 8/)
    end

    it 'Should print out the unexpected token that caused the error' do
      expect { Jsonerino.parse('{"foo" }') }.to raise_error(Jsonerino::JsonParseError, /Unexpected token '}'/)
      expect { Jsonerino.parse('{"foo": : }') }.to raise_error(Jsonerino::JsonParseError, /Unexpected token ':'/)
      expect { Jsonerino.parse('{"foo": ] }') }.to raise_error(Jsonerino::JsonParseError, /Unexpected token ']'/)
    end

    it 'Should throw end of input error when end of input is reached'\
      '(happens with unclosed curly brackets/double qutoes/etc.)' do
      expect { Jsonerino.parse('{"foo }') }
        .to raise_error(Jsonerino::JsonParseError, /End of data while reading object contents of the JSON data/)
      expect { Jsonerino.parse('{"foo" ') }
        .to raise_error(Jsonerino::JsonParseError, /End of data while reading object contents of the JSON data/)
    end

    it 'Should throw runtime error for unsupported characters' do
      expect { Jsonerino.parse('{"foo": % }') }.to raise_error(RuntimeError, /Unexpected character '%'/)
    end
  end
end
