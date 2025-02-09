# frozen_string_literal: true

require 'librum/components/base'

require 'support/deferred/abstract_examples'
require 'support/deferred/options_examples'

RSpec.describe Librum::Components::Base do
  include Spec::Support::Deferred::AbstractExamples
  include Spec::Support::Deferred::OptionsExamples

  subject(:component) { described_class.new(**component_options) }

  shared_context 'when the component defines options' do
    include_context 'with a component subclass'

    before(:example) do
      described_class.option :label

      described_class.option :checked, boolean: true
    end
  end

  shared_context 'with a component subclass' do
    let(:described_class) { Spec::ExampleComponent }

    example_class 'Spec::ExampleComponent', Librum::Components::Base # rubocop:disable RSpec/DescribedClass
  end

  let(:component_options) { {} }

  describe '::AbstractComponentError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:AbstractComponentError)
        .with_value(an_instance_of(Class).and(be < StandardError))
    end
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_any_keywords
    end

    describe 'with invalid component options' do
      let(:component_options) do
        {
          text_color:      '#ff3366',
          text_decoration: 'underline'
        }
      end
      let(:error_message) do
        'invalid options text_color: "#ff3366", text_decoration: "underline" ' \
          "- #{described_class.name} does not define any valid options"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error described_class::InvalidOptionsError, error_message
      end

      wrap_context 'when the component defines options' do
        let(:component_options) do
          {
            checked:         true,
            text_color:      '#ff3366',
            text_decoration: 'underline'
          }
        end
        let(:error_message) do
          'invalid options text_color: "#ff3366", text_decoration: ' \
            "\"underline\" - valid options for #{described_class.name} are " \
            ':checked and :label'
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error described_class::InvalidOptionsError, error_message
        end
      end
    end
  end

  describe '.abstract?' do
    it { expect(described_class).to define_predicate(:abstract) }

    it { expect(described_class.abstract?).to be true }

    wrap_context 'with a component subclass' do
      it { expect(described_class.abstract?).to be false }
    end
  end

  describe '.option' do
    deferred_context 'when the option is defined' do
      before(:example) { described_class.option(name, **meta_options) }
    end

    let(:name)         { 'example_option' }
    let(:meta_options) { {} }
    let(:error_message) do
      "unable to define option ##{name} - #{described_class} is an abstract " \
        'class'
    end

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:option)
        .with(1).arguments
        .and_keywords(:boolean, :default)
    end

    it 'should raise an exception' do
      expect { described_class.option(name, **meta_options) }
        .to raise_error described_class::AbstractComponentError, error_message
    end

    describe 'with boolean: true' do
      let(:meta_options) { super().merge(boolean: true) }
      let(:error_message) do
        "unable to define option ##{name}? - #{described_class} is an " \
          'abstract class'
      end

      it 'should raise an exception' do
        expect { described_class.option(name, **meta_options) }
          .to raise_error described_class::AbstractComponentError, error_message
      end
    end

    wrap_context 'with a component subclass' do
      include_deferred 'should define the configured option'
    end
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

  describe '#components' do
    include_examples 'should define private reader',
      :components,
      -> { an_instance_of(Module) }
  end
end
