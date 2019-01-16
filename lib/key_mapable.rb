# frozen_string_literal: true

require "key_mapable/version"
require "key_mapable/mapper"

# Used to map the instance of the extended class to a new format.
#
# Usage:
#
#   class MyClass
#     extend KeyMapable
#
#     # Define a method called `#to_h` that use the provided map. The keys
#     # will be accessed on the provided subject.
#     define_map(:to_h, subject: :my_reader) do
#       # Map the value of `#name` to the key 'Name'.
#       key_map(:name, 'Name')
#
#       # Map the value of `#maybe_value` to the key 'GuaranteedValue'.
#       # Transform the value by calling `#to_s` first.
#       key_map(:maybe_value, 'GuaranteedValue', &:to_s)
#
#       # Map the key 'Name' to the value provided by the block.
#       key_value('AConstant') { 'Foo' }
#
#       # Map every item returned from `#rows`.
#       array_key_map(:rows) do
#         # Map the value of `#id` to the key 'Id'.
#         key_map(:id, 'Id')
#       end
#     end
#   end
module KeyMapable
  def define_map(method_name, subject: :self, &block)
    define_method(method_name) do
      value = public_send(subject)
      mapper = Mapper.new(value)
      mapper.instance_eval(&block)
      mapper.resolve
    end
  end
end
