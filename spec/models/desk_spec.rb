# frozen_string_literal: true

require_relative '../../app/models/desk'

RSpec.describe Desk do
  context 'when creating a desk' do
    context 'without specified dimensions' do
      let(:desk) { described_class.new }

      it 'creates a desk with 5 length' do
        expect(desk.length).to eq(5)
      end

      it 'creates a desk with 6 width' do
        expect(desk.width).to eq(6)
      end
    end

    context 'with specified dimensions' do
      let(:desk) { described_class.new(10, 15) }

      it 'creates a desk with specified length' do
        expect(desk.length).to eq(10)
      end

      it 'creates a desk with specified width' do
        expect(desk.width).to eq(15)
      end
    end

    context 'with wrong dimensions' do
      let(:desk) { described_class.new(0, 0) }

      it 'raises dimensions error' do
        expect { desk }.to raise_error(Desk::DimensionsError)
      end
    end
  end
end
