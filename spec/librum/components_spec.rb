# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components do
  describe '::Provider' do
    subject(:provider) { described_class::Provider }

    let(:expected_values) do
      {
        'components'    => Plumbum::UNDEFINED,
        'configuration' => Plumbum::UNDEFINED
      }
    end

    include_examples 'should define constant',
      :Provider,
      -> { an_instance_of(Plumbum::ManyProvider) }

    it { expect(provider.values).to be == expected_values }

    it { expect(provider.write_once?).to be true }
  end

  describe '.version' do
    include_examples 'should define class reader',
      :version,
      -> { described_class::VERSION }
  end
end
