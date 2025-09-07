# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Errors::InvalidComponentError do
  it { expect(described_class).to be_a(Class).and be < StandardError }
end
