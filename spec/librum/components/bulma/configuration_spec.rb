# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Configuration do
  subject(:configuration) { described_class.new(**options) }

  deferred_examples 'should define option' \
  do |option_name, option_value = 'value'|
    describe "##{option_name}" do
      include_examples 'should define reader',
        option_name,
        -> { described_class::DEFAULTS[option_name.to_s] }

      context "when initialized with #{option_name}: value" do
        let(:options) { super().merge(option_name => option_value) }

        it 'should return the configured value' do
          expect(configuration.public_send(option_name)).to be == option_value
        end
      end
    end
  end

  let(:options) { {} }

  describe '::DEFAULTS' do
    include_examples 'should define immutable constant',
      :DEFAULTS,
      -> { an_instance_of(Hash) }

    describe 'colors' do
      let(:expected) do
        %w[text link primary info success warning danger]
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

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_any_keywords
    end
  end

  include_deferred 'should define option', :bulma_prefix
end
