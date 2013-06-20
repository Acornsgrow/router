require 'test_helper'

describe Lotus::Utils::String do
  describe '.titleize' do
    it 'returns a titleized string' do
      Lotus::Utils::String.titleize('lotus').must_equal('Lotus')
      Lotus::Utils::String.titleize('lotus_router').must_equal('LotusRouter')
    end

    it 'returns a titleized string from symbol' do
      Lotus::Utils::String.titleize(:lotus).must_equal('Lotus')
      Lotus::Utils::String.titleize(:lotus_router).must_equal('LotusRouter')
    end
  end
end