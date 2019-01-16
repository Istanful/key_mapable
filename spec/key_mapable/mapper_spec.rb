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
      mapper = described_class.new({})

      mapper.key('PrimaryKey') do
        key_value('Key') { 'Value' }
      end

      expect(mapper.structure).to eq({
        'PrimaryKey' => { 'Key' => 'Value' }
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
  end

  describe '#transform' do
    it 'transforms with the given block' do
      object = double(foo: 'bar')
      mapper = described_class.new(object)

      mapper.key_map(:foo, 'Foo') { transform(&:upcase) }

      expect(mapper.structure).to eq({
        'Foo' => 'BAR'
      })
    end
  end
end
