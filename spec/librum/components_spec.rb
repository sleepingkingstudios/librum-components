# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components do
  describe '::Provider' do
    subject(:provider) { described_class::Provider }

    let(:expected_values) do
      {
        'components'    => Plumbum::UNDEFINED,
        'configuration' => Plumbum::UNDEFINED,
        'routes'        => Plumbum::UNDEFINED
      }
    end

    include_examples 'should define constant',
      :Provider,
      -> { an_instance_of(Plumbum::ManyProvider) }

    it { expect(provider.values).to be == expected_values }

    it { expect(provider.write_once?).to be true }
  end

  describe '.root_path' do
    let(:root_path) { __dir__.sub('/spec/librum', '') }

    it { expect(described_class.root_path).to be_a String }

    it { expect(described_class.root_path).to be == root_path }
  end

  describe '.stylesheets_path' do
    let(:root_path) { __dir__.sub('/spec/librum', '') }
    let(:expected)  { File.join(root_path, 'app', 'assets', 'stylesheets') }

    it { expect(described_class.stylesheets_path).to be_a String }

    it { expect(described_class.stylesheets_path).to be == expected }
  end

  describe '.version' do
    include_examples 'should define class reader',
      :version,
      -> { described_class::VERSION }
  end
end
