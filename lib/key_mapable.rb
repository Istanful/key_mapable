# frozen_string_literal: true

require "key_mapable/version"
require "key_mapable/mapper"

module KeyMapable
  def define_map(method_name, resolve: ->(val) { val }, subject: :itself, &block)
    define_method(method_name) do
      value = public_send(subject)
      mapper = Mapper.new(value)
      mapper.instance_eval(&block)
      resolve.call(mapper.tree)
    end
  end
end
