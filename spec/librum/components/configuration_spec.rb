# frozen_string_literal: true

require 'librum/components/configuration'

RSpec.describe Librum::Components::Configuration do
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

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '::DEFAULTS' do
    include_examples 'should define immutable constant',
      :DEFAULTS,
      -> { an_instance_of(Hash) }
  end

  describe '.default' do
    subject(:configuration) { described_class.default }

    include_examples 'should define class reader',
      :default,
      -> { an_instance_of(described_class) }

    it { expect(described_class.default).to be configuration }

    it { expect(configuration.options).to be == described_class::DEFAULTS }
  end

  describe '.instance' do
    let(:instance) { described_class.instance }

    include_examples 'should define class reader',
      :instance,
      -> { an_instance_of(described_class) }

    it { expect(described_class.instance).to be instance }

    it { expect(instance.options).to be == described_class::DEFAULTS }
  end

  describe '.instance=' do
    let(:colors) { %i[red orange yellow green blue indigo violet] }
    let(:value)  { described_class.new(colors:) }

    around(:example) do |example|
      config = described_class.instance

      example.call
    ensure
      described_class.instance = config
    end

    include_examples 'should define class writer', :instance

    it 'should set the memoized instance' do
      expect { described_class.instance = value }
        .to change(described_class, :instance)
        .to be value
    end
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

  include_deferred 'should define option', :default_icon_family

  describe '#colors' do
    let(:expected) { Set.new(described_class::DEFAULTS['colors']) }

    include_examples 'should define reader', :colors, -> { expected }

    context 'when initialized with colors: value' do
      let(:colors)   { %i[red orange yellow green blue indigo violet] }
      let(:options)  { super().merge(colors:) }
      let(:expected) { Set.new(colors.map(&:to_s)) }

      it { expect(configuration.colors).to be == expected }
    end
  end

  describe '#icon_families' do
    let(:expected) { Set.new(described_class::DEFAULTS['icon_families']) }

    include_examples 'should define reader', :icon_families, -> { expected }

    context 'when initialized with icon_families: value' do
      let(:icon_families) { %i[bootstrap material-design iconicons] }
      let(:options)       { super().merge(icon_families:) }
      let(:expected)      { Set.new(icon_families.map(&:to_s)) }

      it { expect(configuration.icon_families).to be == expected }
    end
  end

  describe '#options' do
    let(:expected) do
      options = tools.hsh.convert_keys_to_strings(self.options)

      described_class::DEFAULTS.merge(options)
    end

    include_examples 'should define reader',
      :options,
      -> { an_instance_of(Hash) }

    it { expect(configuration.options.frozen?).to be true }

    it { expect(configuration.options).to be == expected }

    context 'when initialized with options with string keys' do
      let(:options) { { 'key' => 'value' } }

      it { expect(configuration.options).to be == expected }
    end

    context 'when initialized with options with symbol keys' do
      let(:options) { { key: 'value' } }

      it { expect(configuration.options).to be == expected }
    end
  end
end
