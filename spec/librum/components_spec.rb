# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components do
  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '::PROVIDER_KEYS' do
    let(:expected) { %w[components configuration routes] }

    include_examples 'should define immutable constant',
      :PROVIDER_KEYS,
      -> { be == expected }
  end

  describe '.javascript_path' do
    let(:root_path) { __dir__.sub('/spec/librum', '') }
    let(:expected)  { File.join(root_path, 'app', 'javascript') }

    it 'should define the class method' do
      expect(described_class).to respond_to(:javascript_path).with(0).arguments
    end

    it { expect(described_class.javascript_path).to be_a String }

    it { expect(described_class.javascript_path).to be == expected }
  end

  describe '.provider' do
    let(:provider) { described_class.provider }
    let(:expected_values) do
      described_class::PROVIDER_KEYS.to_h { |key| [key, Plumbum::UNDEFINED] } # rubocop:disable Rails/IndexWith
    end

    around(:example) do |example|
      previous = described_class.instance_variable_get(:@provider)

      described_class.instance_variable_set(:@provider, nil)

      example.call
    ensure
      described_class.instance_variable_set(:@provider, previous)
    end

    include_examples 'should define class reader',
      :provider,
      -> { an_instance_of(Plumbum::ManyProvider) }

    it { expect(provider.values).to be == expected_values }

    it { expect(provider.write_once?).to be true }

    it 'should cache the value' do
      expect(described_class.provider).to be provider
    end
  end

  describe '.provider=' do
    around(:example) do |example|
      previous = described_class.instance_variable_get(:@provider)

      described_class.instance_variable_set(:@provider, nil)

      example.call
    ensure
      described_class.instance_variable_set(:@provider, previous)
    end

    include_examples 'should define class writer', :provider=

    describe 'with nil' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          expected: Plumbum::Provider
        )
      end

      it 'should raise an exception' do
        expect { described_class.provider = nil }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          expected: Plumbum::Provider
        )
      end

      it 'should raise an exception' do
        expect { described_class.provider = Object.new.freeze }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a Provider with invalid keys' do
      let(:value) { Plumbum::ManyProvider.new }
      let(:error_message) do
        'provider does not define required keys ' \
          "#{described_class::PROVIDER_KEYS.map(&:inspect).join(', ')}"
      end

      it 'should raise an exception' do
        expect { described_class.provider = value }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a Provider with valid keys and undefined values' do
      let(:value) do
        values =
          described_class::PROVIDER_KEYS # rubocop:disable Rails/IndexWith
          .to_h { |key| [key, Plumbum::UNDEFINED] }

        Plumbum::ManyProvider.new(values:)
      end

      it 'should set the provider' do
        described_class.provider = value

        expect(described_class.provider).to be value
      end

      context 'when the provider is already set' do
        before(:example) { described_class.provider }

        it 'should raise an exception' do
          expect { described_class.provider = value }.to raise_error(
            Librum::Components::Errors::ExistingProviderError,
            'provider already exists'
          )
        end
      end
    end

    describe 'with a Provider with valid keys and defined values' do
      let(:value) do
        values = {
          components:    Module.new,
          configuration: Librum::Components::Configuration.default,
          routes:        Struct.new(:root_path).new('/')
        }

        Plumbum::ManyProvider.new(values:)
      end

      it 'should set the provider' do
        described_class.provider = value

        expect(described_class.provider).to be value
      end

      context 'when the provider is already set' do
        before(:example) { described_class.provider }

        it 'should raise an exception' do
          expect { described_class.provider = value }.to raise_error(
            Librum::Components::Errors::ExistingProviderError,
            'provider already exists'
          )
        end
      end
    end
  end

  describe '.root_path' do
    let(:root_path) { __dir__.sub('/spec/librum', '') }

    it 'should define the class method' do
      expect(described_class).to respond_to(:root_path).with(0).arguments
    end

    it { expect(described_class.root_path).to be_a String }

    it { expect(described_class.root_path).to be == root_path }
  end

  describe '.stylesheets_path' do
    let(:root_path) { __dir__.sub('/spec/librum', '') }
    let(:expected)  { File.join(root_path, 'app', 'assets', 'stylesheets') }

    it 'should define the class method' do
      expect(described_class).to respond_to(:stylesheets_path).with(0).arguments
    end

    it { expect(described_class.stylesheets_path).to be_a String }

    it { expect(described_class.stylesheets_path).to be == expected }
  end

  describe '.version' do
    include_examples 'should define class reader',
      :version,
      -> { described_class::VERSION }
  end
end
