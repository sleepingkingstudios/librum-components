# frozen_string_literal: true

require 'librum/components/errors/existing_provider_error'

RSpec.describe Librum::Components::Errors::ExistingProviderError do
  it { expect(described_class).to be_a(Class).and be < StandardError }
end
