module Helpers
  def self.numeric?(chr)
    !chr.match(/^[0-9]$/).nil?
  end

  def self.hex?(chr)
    !chr.match(/^\h+$/).nil?
  end

  def self.alphanumeric?(chr)
    !chr.match(/^\w+$/).nil?
  end
end
