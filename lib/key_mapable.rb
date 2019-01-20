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
      value = Accessor::Method.access(self, subject)
      accessor = Accessor.for(access)
      resolve.call(Mapper.map(value, accessor, &block))
    end
  end
end
