class JsonValue
  attr_accessor :start, :finish
end

class JsonNull < JsonValue
  def resolve
    nil
  end
end

class JsonBool < JsonValue
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def resolve
    @value
  end
end

class JsonNumber < JsonValue
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def resolve
    @value
  end
end

class JsonString < JsonValue
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def resolve
    @value
  end
end

class JsonArray < JsonValue
  attr_reader :value

  def initialize()
    @value = []
  end

  def push(value)
    raise 'Value is not instnace of JsonValue' unless value.is_a? JsonValue

    @value.push(value)
  end

  def resolve
    @value.map(&:resolve)
  end
end

class JsonObject < JsonValue
  attr_reader :value

  def initialize()
    @value = {}
  end

  def push(key, value)
    raise 'Value is not instnace of JsonValue' unless value.is_a? JsonValue

    @value[key] = value
  end

  def resolve
    @value.keys.each do |key|
      @value[key] = @value[key].resolve
    end
    @value
  end
end
