# frozen_string_literal: true

require 'librum/components/options'

require 'support/deferred/abstract_examples'
require 'support/deferred/options_examples'

RSpec.describe Librum::Components::Options do
  include Spec::Support::Deferred::AbstractExamples
  include Spec::Support::Deferred::OptionsExamples

  subject(:component) { described_class.new(**component_options) }

  shared_context 'when the component defines options' do
    before(:example) do
      described_class.option :label

      described_class.option :checked, boolean: true
    end
  end

  let(:described_class)   { Spec::ExampleComponent }
  let(:component_options) { {} }

  example_class 'Spec::ExampleComponent' do |klass|
    klass.include Librum::Components::Options # rubocop:disable RSpec/DescribedClass
  end

  describe '::DuplicateOptionError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:DuplicateOptionError)
        .with_value(an_instance_of(Class).and(be < StandardError))
    end
  end

  describe '::InvalidOptionsError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:InvalidOptionsError)
        .with_value(an_instance_of(Class).and(be < ArgumentError))
    end
  end

  describe '.option' do
    deferred_context 'when the option is defined' do
      before(:example) { described_class.option(name, **meta_options) }
    end

    let(:name)         { 'example_option' }
    let(:meta_options) { {} }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:option)
        .with(1).arguments
        .and_keywords(:boolean, :default)
    end

    include_deferred 'should define the configured option'
  end

  describe '.options' do
    include_examples 'should define class reader', :options, -> { {} }

    wrap_context 'when the component defines options' do
      let(:expected) do
        {
          'checked' => Librum::Components::Option.new(
            name:    'checked',
            boolean: true
          ),
          'label'   => Librum::Components::Option.new(name: 'label')
        }
      end

      it { expect(described_class.options).to be == expected }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, -> { {} }

    wrap_context 'when the component defines options' do
      it { expect(component.options).to be == {} }

      context 'when initialized with valid options' do
        let(:component_options) do
          super().merge(label: 'Do Not Push', checked: true)
        end

        it { expect(component.options).to be == component_options }
      end
    end
  end
end
