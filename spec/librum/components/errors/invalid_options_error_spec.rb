# frozen_string_literal: true

require 'librum/components/errors/invalid_options_error'

RSpec.describe Librum::Components::Errors::InvalidOptionsError do
  it { expect(described_class).to be_a(Class).and be < ArgumentError }
end
