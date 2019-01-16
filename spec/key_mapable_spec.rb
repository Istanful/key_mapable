# frozen_string_literal: true

require 'ostruct'

RSpec.describe KeyMapable do
  it 'has a version number' do
    expect(KeyMapable::VERSION).not_to be nil
  end

  describe '#define_map' do
    context 'when using all features' do
      let(:mock_class) do
        mock_resolve = lambda { |tree|
          tree.transform_keys(&:to_sym)
        }

        Class.new do
          extend KeyMapable

          define_map(:to_h, resolve: mock_resolve, subject: :my_reader) do
            key_map(:name, 'Name')
            key_map(:maybe_value, 'GuaranteedValue', &:to_s)
            key_value('AConstant') { 'Foo' }
            array_key_map(:rows, 'Rows') do
              key_map(:id, 'Id')
            end
          end

          def my_reader
            OpenStruct.new(
              name: 'Bob',
              maybe_value: nil,
              rows: rows
            )
          end

          def rows
            [OpenStruct.new(id: 1)]
          end
        end
      end

      it 'works with all provided features' do
        result = mock_class.new.to_h

        expect(result).to eq({
          'Name': 'Bob',
          'GuaranteedValue':'',
          'AConstant': 'Foo',
          'Rows': [
            { 'Id' => 1 }
          ]
        })
      end
    end

    context 'when not providing a resolve method' do
      let(:mock_class) do
        Class.new do
          extend KeyMapable

          define_map(:to_h, subject: :my_reader) do
            key_map(:foo, 'Foo')
          end

          def my_reader
            OpenStruct.new(foo: 'bar')
          end
        end
      end

      it 'returns the hash tree' do
        result = mock_class.new.to_h

        expect(result.to_h).to eq({ 'Foo' => 'bar' })
      end
    end
  end
end
