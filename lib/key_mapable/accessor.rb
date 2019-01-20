# frozen_string_literal: true

class KeyMapable::Accessor
  class Method
    def self.access(subject, key)
      subject.public_send(key)
    end
  end

  class Hash
    def self.access(subject, key)
      subject[key]
    end
  end

  ACCESSORS = {
    method: Method,
    hash: Hash
  }

  def self.for(accessor_or_name)
    ACCESSORS.fetch(accessor_or_name, accessor_or_name)
  end
end
