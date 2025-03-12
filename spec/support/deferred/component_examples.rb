# frozen_string_literal: true

require 'support/deferred'
require 'support/deferred/options_examples'

module Spec::Support::Deferred
  module ComponentExamples
    include RSpec::SleepingKingStudios::Deferred::Provider
    include Spec::Support::Deferred::OptionsExamples

    deferred_examples 'should be an abstract view component' do |base_class|
      include Spec::Support::Deferred::ComponentExamples

      deferred_context 'with a component subclass' do
        let(:described_class) { Spec::ExampleComponent }

        example_class 'Spec::ExampleComponent', base_class
      end

      deferred_context 'when the component defines options' do
        before(:example) do
          described_class.option :label

          described_class.option :checked, boolean: true
        end
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

    deferred_examples 'should be a view component' do
      describe '.new' do
        it 'should define the constructor' do
          expect(described_class)
            .to be_constructible
            .with(0).arguments
            .and_keywords(:configuration)
            .and_any_keywords
        end

        include_deferred 'should validate the component options'
      end

      describe '.abstract?' do
        it { expect(described_class).to define_predicate(:abstract) }

        it { expect(described_class.abstract?).to be_boolean }
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
        include_examples 'should define private reader',
          :components,
          -> { an_instance_of(Module) }
      end

      describe '#configuration' do
        include_examples 'should define reader',
          :configuration,
          -> { an_instance_of(Librum::Components::Configuration) }
      end

      describe '#options' do
        include_examples 'should define reader',
          :options,
          -> { an_instance_of(Hash) }
      end
    end

    deferred_examples 'should validate the component options' do
      describe 'with invalid component options' do
        let(:component_options) do
          {
            invalid_color:      '#ff3366',
            invalid_decoration: 'underline'
          }
        end
        let(:valid_options) do
          described_class
            .options
            .keys
            .sort
            .map { |key| ":#{key}" }
            .then { |ary| tools.ary.humanize_list(ary) }
        end
        let(:error_message) do
          message =
            'invalid options invalid_color: "#ff3366", invalid_decoration: ' \
            '"underline" - '

          if described_class.options.empty?
            "#{message}#{described_class.name} does not define any " \
              'valid options'
          else
            "#{message}valid options for #{described_class.name} are " \
              "#{valid_options}"
          end
        end

        define_method :tools do
          SleepingKingStudios::Tools::Toolbelt.instance
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              error_message
            )
        end
      end
    end
  end
end
