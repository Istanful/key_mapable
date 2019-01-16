# frozen_string_literal: true

# Used internally by the KeyMapable concern.
class KeyMapable::Mapper
  attr_reader :value

  def initialize(value)
    @value = value
    @tree = {}
  end

  def key(name, &block)
    child_mapper = self.class.new(value)
    child_mapper.instance_eval(&block)
    @tree[name] = child_mapper.resolve
  end

  def key_map(original_key, new_key, &block)
    original_value = value.public_send(original_key)
    if block_given?
      child_mapper = self.class.new(original_value)
      @tree[new_key] = child_mapper.instance_eval do
        yield(original_value)
      end
    else
      @tree[new_key] = original_value
    end
  end

  def key_value(key)
    @tree[key] = yield()
  end

  def array_key_map(original_key, new_key, &block)
    original_value = value.public_send(original_key)
    @tree[new_key] = original_value.map do |item|
      child_mapper = self.class.new(item)
      child_mapper.instance_eval(&block)
      child_mapper.resolve
    end
  end

  def resolve
    @tree
  end
end
