require_relative '../../lib/jsonerino'

describe Jsonerino do
  describe '#parse (primitive)' do
    it 'Should parse strings properly' do
      output = Jsonerino.parse '"foo"'
      expect(output).to eql('foo')
    end

    it 'Should parse strings that contain escape sequences' do
      output = Jsonerino.parse "\"foo\n\t\""
      expect(output).to eql("foo\n\t")
    end

    it 'Should parse strings that contain unicode escape sequences' do
      output = Jsonerino.parse "\"foo\u0269\""
      expect(output).to eql("foo\u0269")
    end

    it 'Should parse booleans properly' do
      expect(Jsonerino.parse('true')).to eql(true)
      expect(Jsonerino.parse('false')).to eql(false)
    end

    it 'Should parse numbers properly' do
      expect(Jsonerino.parse('1.5e-5')).to eql(1.5e-5)
    end

    it 'Should parse null values properly' do
      expect(Jsonerino.parse('null')).to eql(nil)
    end
  end
end
