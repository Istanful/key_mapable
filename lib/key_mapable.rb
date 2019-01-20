# frozen_string_literal: true

require "key_mapable/version"
require "key_mapable/accessor"
require "key_mapable/mapper"

module KeyMapable
  def define_map(method_name,
                 resolve: ->(val) { val },
                 subject: :itself,
                 access: :method, &block)
    define_method(method_name) do
      value = public_send(subject)
      accessor = Accessor.for(access)
      mapper = Mapper.new(value, accessor)
      mapper.instance_eval(&block)
      resolve.call(mapper.structure)
    end
  end
end
