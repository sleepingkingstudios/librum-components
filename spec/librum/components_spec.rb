# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components do
  describe '.version' do
    include_examples 'should define class reader',
      :version,
      -> { described_class::VERSION }
  end
end
