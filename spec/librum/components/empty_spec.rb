# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Empty do
  it { expect(described_class).to be_a Module }

  it { expect(described_class.constants(false)).to be == [] }

  it { expect(described_class.frozen?).to be true }
end
