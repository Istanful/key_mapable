# frozen_string_literal: true

# Used internally by the KeyMapable concern.
class KeyMapable::Mapper
  attr_reader :subject, :structure, :accessor

  def initialize(subject, accessor = KeyMapable::Accessor::Method)
    @subject = subject
    @structure = {}
    @accessor = accessor
  end

  def self.map(subject, accessor, &block)
    mapper = new(subject, accessor)
    mapper.instance_eval(&block)
    mapper.structure
  end

  def key_value(name)
    @structure[name] = yield(subject)
  end

  def key(name, &block)
    @structure[name] = map(&block)
  end

  def key_map(original_key, new_key, transform: ->(val) { val }, &block)
    next_subject = transform.call(access(original_key))

    return @structure[new_key] = next_subject unless block_given?

    @structure[new_key] = map(next_subject, &block)
  end

  def array_key_map(original_key, new_key, &block)
    next_subject = access(original_key)
    @structure[new_key] = next_subject.map { |item| map(item, &block) }
  end

  private

  def access(key)
    accessor.access(subject, key)
  end

  def map(next_subject = subject, &block)
    self.class.map(next_subject, accessor, &block)
  end
end
