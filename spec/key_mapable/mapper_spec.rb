RSpec.describe KeyMapable::Mapper do
  describe '#key_value' do
    context 'when no block provided' do
      it 'sets the given key to the value returned by the block' do
        mapper = described_class.new({})

        mapper.key_value('Key') { 'Value' }

        expect(mapper.structure['Key']).to eq('Value')
      end
    end
  end

  describe '#key' do
    it 'sets the given key to the structure built by the block' do
      mapper = described_class.new(double(meta: 'abc'))

      mapper.key('PrimaryKey') do
        key_value('Key') { |value| value.meta.upcase }
      end

      expect(mapper.structure).to eq({
        'PrimaryKey' => { 'Key' => 'ABC' }
      })
    end
  end

  describe '#key_map' do
    context 'when no block given' do
      it 'sets the key to the original value' do
        object = double(foo: 'bar')
        mapper = described_class.new(object)

        mapper.key_map(:foo, 'Foo')

        expect(mapper.structure['Foo']).to eq('bar')
      end
    end

    context 'when given a block describing a structure' do
      it 'sets the key to the structure built by the block' do
        object = double(foo: double(bar: 'Baz'))
        mapper = described_class.new(object)

        mapper.key_map(:foo, 'Foo') do
          key_map(:bar, 'Bar')
        end

        expect(mapper.structure).to eq({
          'Foo' => { 'Bar' => 'Baz' }
        })
      end
    end

    context 'when given a transform' do
      it 'sets the key and transforms the value' do
        object = double(foo: 'bar')
        mapper = described_class.new(object)

        mapper.key_map(:foo, 'Foo', transform: ->(val) { val.upcase })

        expect(mapper.structure['Foo']).to eq('BAR')
      end
    end

    context 'when given an accessor' do
      let(:mock_accessor) do
        Class.new do
          def self.access(object, key)
            object[key]
          end
        end
      end

      it 'uses that accessor' do
        object = { foo: 'bar' }
        mapper = described_class.new(object, mock_accessor)

        mapper.key_map(:foo, 'Foo')

        expect(mapper.structure['Foo']).to eq('bar')
      end
    end
  end
end
