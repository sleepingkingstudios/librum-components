# frozen_string_literal: true

require 'librum/components/bulma/configuration'

RSpec.describe Librum::Components::Bulma::Configuration do
  describe '::DEFAULTS' do
    include_examples 'should define immutable constant',
      :DEFAULTS,
      -> { an_instance_of(Hash) }

    describe 'colors' do
      let(:expected) do
        %w[primary link info success warning danger]
      end

      it { expect(described_class::DEFAULTS['colors']).to be == expected }
    end

    describe 'default_icon_family' do
      it 'should configured the default icon family' do
        expect(described_class::DEFAULTS['default_icon_family'])
          .to be == 'fa-solid'
      end
    end

    describe 'icon_families' do
      let(:expected) do
        Librum::Components::Icons::FontAwesome::ICON_FAMILIES.to_a
      end

      it 'should configured the icon families' do
        expect(described_class::DEFAULTS['icon_families']).to be == expected
      end
    end
  end

  describe '.default' do
    subject(:configuration) { described_class.default }

    include_examples 'should define class reader',
      :default,
      -> { an_instance_of(described_class) }

    it { expect(described_class.default).to be configuration }

    it { expect(configuration.options).to be == described_class::DEFAULTS }
  end
end
