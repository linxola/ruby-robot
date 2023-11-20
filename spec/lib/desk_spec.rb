# frozen_string_literal: true

require_relative '../../lib/desk'

RSpec.describe Desk do
  context 'when creating a desk' do
    let(:desk) { described_class.new(10, 15) }

    it 'creates a desk with specified length' do
      expect(desk.length).to eq(10)
    end

    it 'creates a desk with specified width' do
      expect(desk.width).to eq(15)
    end
  end
end
