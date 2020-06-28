require_relative '../../lib/jsonerino'

describe Jsonerino do
  let(:complex_json_str) do
    '
        {
          "problems": [{
              "Diabetes":[{
                  "medications":[{
                      "medicationsClasses":[{
                          "className":[{
                              "associatedDrug":[{"name":"asprin", "dose":"", "strength":"500 mg"}],
                              "associatedDrug#2":[{"name":"somethingElse", "dose":"", "strength":"500 mg"}]
                          }],
                          "className2":[{
                              "associatedDrug":[{ "name":"asprin", "dose":"", "strength":"500 mg" }],
                              "associatedDrug#2":[{ "name":"somethingElse", "dose":"", "strength":"500 mg"}]
                          }]
                      }]
                  }],
                  "labs":[{"missing_field": "missing_value"}]
              }],
              "Asthma":[{}]
          }]
        }
      '
  end

  let(:complex_json) do
    {
      'problems' => [{
        'Diabetes' => [{
          'medications' => [{
            'medicationsClasses' => [{
              'className' => [{
                'associatedDrug' => [{ 'name' => 'asprin', 'dose' => '', 'strength' => '500 mg' }],
                'associatedDrug#2' => [{ 'name' => 'somethingElse', 'dose' => '', 'strength' => '500 mg' }]
              }],
              'className2' => [{
                'associatedDrug' => [{ 'name' => 'asprin', 'dose' => '', 'strength' => '500 mg' }],
                'associatedDrug#2' => [{ 'name' => 'somethingElse', 'dose' => '', 'strength' => '500 mg' }]
              }]
            }]
          }],
          'labs' => [{
            'missing_field' => 'missing_value'
          }]
        }],
        'Asthma' => [{}]
      }]
    }
  end

  describe '#parse (complex)' do
    it 'Should parse empty objects' do
      expect(Jsonerino.parse('{}')).to eql({})
    end

    it 'Should parse empty arrays' do
      expect(Jsonerino.parse('[]')).to eql([])
    end

    it 'Should parse objects that have values' do
      str = '
        {
          "str" : "bar",
          "bool" : true,
          "null" : null,
          "number" : 11
        }
      '
      expect(Jsonerino.parse(str)).to eql(
        {
          'str' => 'bar',
          'bool' => true,
          'null' => nil,
          'number' => 11
        }
      )
    end

    it 'Should parse arrays that contain random values' do
      str = '
        [
          true,
          false,
          11.5,
          "string",
          null
        ]
      '
      expect(Jsonerino.parse(str)).to eql(
        [
          true,
          false,
          11.5,
          'string',
          nil
        ]
      )
    end

    it 'Should parse complex nested JSON data (pass 1)' do
      str = '
        [
          {"arr" : [1, 2, 3, { "four" : 4 }]},
          true,
          [{"a" : "b", "c" : null}, null]
        ]
      '

      expect(Jsonerino.parse(str)).to eql(
        [
          { 'arr' => [1, 2, 3, { 'four' => 4 }] },
          true,
          [{ 'a' => 'b', 'c' => nil }, nil]
        ]
      )
    end

    it 'Should parse complex nested JSON data (pass 1)' do
      str = '
        [
          {"arr" : [1, 2, 3, { "four" : 4 }]},
          true,
          [{"a" : "b", "c" : null}, null]
        ]
      '

      expect(Jsonerino.parse(str)).to eql(
        [
          { 'arr' => [1, 2, 3, { 'four' => 4 }] },
          true,
          [{ 'a' => 'b', 'c' => nil }, nil]
        ]
      )
    end

    it 'Should parse complex nested JSON data (pass 2)' do
      expect(Jsonerino.parse(complex_json_str)).to eql(complex_json)
    end
  end
end
