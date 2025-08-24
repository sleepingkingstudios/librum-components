# frozen_string_literal: true

require 'support/deferred'
require 'support/deferred/abstract_examples'
require 'support/deferred/configuration_examples'
require 'support/deferred/options_examples'

module Spec::Support::Deferred
  module ComponentExamples
    include RSpec::SleepingKingStudios::Deferred::Provider
    include Spec::Support::Deferred::ConfigurationExamples
    include Spec::Support::Deferred::OptionsExamples

    define_method :pad do |str, int|
      first, *rest = str.strip.lines

      rest =
        rest.map { |line| line.strip.empty? ? "\n" : "#{' ' * int}#{line}" }

      [first, *rest].join
    end

    deferred_examples 'should be an abstract view component' do |base_class|
      include Spec::Support::Deferred::AbstractExamples
      include Spec::Support::Deferred::ComponentExamples

      deferred_context 'with a component subclass' do
        let(:described_class) { Spec::ExampleComponent }

        example_class 'Spec::ExampleComponent', base_class
      end

      include_deferred 'should be a view component'

      describe '.new' do
        wrap_deferred 'when the component defines options' do
          include_deferred 'with a component subclass'

          include_deferred 'should validate the component options'
        end
      end

      describe '.abstract?' do
        it { expect(described_class.abstract?).to be true }

        wrap_deferred 'with a component subclass' do
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
          "unable to define option ##{name} - #{described_class} is an " \
            'abstract class'
        end

        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:option)
            .with(1).arguments
            .and_keywords(:boolean, :default)
        end

        it 'should raise an exception' do
          expect { described_class.option(name, **meta_options) }
            .to raise_error(
              described_class::AbstractComponentError,
              error_message
            )
        end

        describe 'with boolean: true' do
          let(:meta_options) { super().merge(boolean: true) }
          let(:error_message) do
            "unable to define option ##{name}? - #{described_class} is an " \
              'abstract class'
          end

          it 'should raise an exception' do
            expect { described_class.option(name, **meta_options) }
              .to raise_error(
                described_class::AbstractComponentError,
                error_message
              )
          end
        end

        wrap_deferred 'with a component subclass' do
          include_deferred 'should define the configured option'
        end
      end

      describe '.options' do
        wrap_deferred 'when the component defines options' do
          let(:expected) do
            {
              'checked' => Librum::Components::Option.new(
                name:    'checked',
                boolean: true
              ),
              'label'   => Librum::Components::Option.new(name: 'label')
            }
          end

          include_deferred 'with a component subclass'

          it { expect(described_class.options).to be == expected }
        end
      end

      describe '#components' do
        let(:default_components) do
          next super() if defined?(super())

          Librum::Components::Empty
        end

        include_examples 'should define reader',
          :components,
          -> { match(default_components) }

        wrap_deferred 'with components', Module.new do
          it { expect(subject.components).to match(expected_components) }
        end
      end

      describe '#configuration' do
        let(:default_configuration) do
          next super() if defined?(super())

          Librum::Components::Configuration.default
        end

        include_examples 'should define reader',
          :configuration,
          -> { match(default_configuration) }

        wrap_deferred 'with configuration', custom_key: 'custom_value' do
          it { expect(subject.configuration).to match(expected_configuration) }
        end
      end

      describe '#options' do
        wrap_deferred 'when the component defines options' do
          include_deferred 'with a component subclass'

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

    deferred_examples 'should be a view component' \
    do |allow_extra_options: false, layout: false|
      describe '.new' do
        it 'should define the constructor' do
          expect(described_class)
            .to be_constructible
            .with(0).arguments
            .and_keywords(:configuration)
            .and_any_keywords
        end

        unless allow_extra_options
          include_deferred 'should validate the component options'
        end
      end

      describe '.abstract?' do
        it { expect(described_class).to define_predicate(:abstract) }

        it { expect(described_class.abstract?).to be_boolean }
      end

      describe '.build' do
        it { expect(described_class).to respond_to(:build).with(1).argument }

        describe 'with nil' do
          let(:value) { nil }
          let(:error_message) do
            "unable to build component with parameters #{value.inspect}"
          end

          it 'should raise an exception' do
            expect { described_class.build(value) }
              .to raise_error Librum::Components::Base::InvalidComponentError,
                error_message
          end
        end

        describe 'with an Object' do
          let(:value) { Object.new.freeze }
          let(:error_message) do
            "unable to build component with parameters #{value.inspect}"
          end

          it 'should raise an exception' do
            expect { described_class.build(value) }
              .to raise_error Librum::Components::Base::InvalidComponentError,
                error_message
          end
        end

        describe 'with a ViewComponent' do
          let(:value) { ViewComponent::Base.new }
          let(:error_message) do
            "#{value.inspect} is not an instance of #{described_class}"
          end

          it 'should raise an exception' do
            expect { described_class.build(value) }
              .to raise_error Librum::Components::Base::InvalidComponentError,
                error_message
          end
        end

        describe 'with an instance of the class' do
          it { expect(described_class.build(component)).to be component }
        end

        if described_class.options.any? || !allow_extra_options
          describe 'with invalid options' do
            let(:value) do
              {
                invalid_color:      '#ff3366',
                invalid_decoration: 'underline'
              }
            end

            it 'should raise an exception' do
              expect { described_class.build(value) }.to raise_error(
                Librum::Components::Options::InvalidOptionsError
              )
            end
          end
        end

        describe 'with valid options' do
          it 'should build a component' do
            expect(described_class.build(component_options))
              .to be_a described_class
          end
        end
      end

      describe '.options' do
        include_examples 'should define class reader',
          :options,
          -> { an_instance_of(Hash) }
      end

      describe '#class_names' do
        let(:arguments) { [] }
        let(:keywords)  { {} }
        let(:output)    { component.class_names(*arguments, **keywords) }

        it 'should define the method' do
          expect(component)
            .to respond_to(:class_names)
            .with(0).arguments
            .and_unlimited_arguments
            .and_keywords(:prefix)
        end

        describe 'with no arguments' do
          it { expect(output).to be == '' }

          describe 'with prefix: value' do
            let(:keywords) { super().merge(prefix: 'spec-') }

            it { expect(output).to be == '' }
          end
        end

        describe 'with string arguments' do
          let(:arguments) { ['color-red', 'shape-rectangle corners-rounded'] }
          let(:expected)  { 'color-red shape-rectangle corners-rounded' }

          it { expect(output).to be == expected }

          describe 'with prefix: value' do
            let(:keywords) { super().merge(prefix: 'spec-') }
            let(:expected) do
              'spec-color-red spec-shape-rectangle spec-corners-rounded'
            end

            it { expect(output).to be == expected }
          end
        end

        describe 'with mixed arguments' do
          let(:arguments) do
            [
              nil,
              false,
              :'color-red',
              ['shape-rectangle corners-rounded']
            ]
          end
          let(:expected) { 'color-red shape-rectangle corners-rounded' }

          it { expect(output).to be == expected }

          describe 'with prefix: value' do
            let(:keywords) { super().merge(prefix: 'spec-') }
            let(:expected) do
              'spec-color-red spec-shape-rectangle spec-corners-rounded'
            end

            it { expect(output).to be == expected }
          end
        end
      end

      describe '#components' do
        include_examples 'should define reader',
          :components,
          -> { an_instance_of(Module) }
      end

      describe '#configuration' do
        include_examples 'should define reader',
          :configuration,
          -> { be_a(Librum::Components::Configuration) }
      end

      describe '#is_layout?' do
        include_examples 'should define predicate', :is_layout, -> { layout }
      end

      describe '#options' do
        include_examples 'should define reader',
          :options,
          -> { an_instance_of(Hash) }
      end
    end
  end
end
