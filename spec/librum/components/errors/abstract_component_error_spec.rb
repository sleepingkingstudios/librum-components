# frozen_string_literal: true

require 'librum/components/errors/abstract_component_error'

RSpec.describe Librum::Components::Errors::AbstractComponentError do
  it { expect(described_class).to be_a(Class).and be < StandardError }
end
