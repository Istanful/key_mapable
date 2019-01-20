# frozen_string_literal: true

class KeyMapable::Accessor::Method
  def self.access(subject, key)
    subject.public_send(key)
  end
end
