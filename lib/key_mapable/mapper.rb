# frozen_string_literal: true

# Used internally by the KeyMapable concern.
class KeyMapable::Mapper
  attr_reader :subject, :structure

  def initialize(subject)
    @subject = subject
    @structure = {}
  end

  def key_value(key)
    @structure[key] = yield()
  end

  def key(name, &block)
    child_mapper = self.class.new(subject)
    child_mapper.instance_eval(&block)
    @structure[name] = child_mapper.resolve
  end

  def key_map(original_key, new_key, transform: ->(val) { val }, &block)
    original_subject = subject.public_send(original_key)
    transformed_subject = transform.call(original_subject)
    if block_given?
      child_mapper = self.class.new(transformed_subject)
      child_mapper.instance_eval &block
      @structure[new_key] = child_mapper.resolve
    else
      @structure[new_key] = transformed_subject
    end
  end

  def array_key_map(original_key, new_key, &block)
    original_subject = subject.public_send(original_key)
    @structure[new_key] = original_subject.map do |item|
      child_mapper = self.class.new(item)
      child_mapper.instance_eval(&block)
      child_mapper.resolve
    end
  end

  def resolve
    @structure
  end
end
