# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Options::Validator do
  include Librum::Components::RSpec::Deferred::ConfigurationExamples
  include Librum::Components::RSpec::Deferred::OptionsExamples

  subject(:validator) do
    described_class.new(options:, **validator_options)
  end

  deferred_context 'when initialized with options' do
    let(:raw_options) do
      {
        checked: { boolean: true },
        label:   {}
      }
    end
  end

  let(:raw_options)    { {} }
  let(:options)        do
    raw_options.to_h do |name, item|
      [name, Librum::Components::Option.new(name: name.to_s, **item)]
    end
  end
  let(:validator_options) { {} }

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:allow_extra_options, :options)
    end
  end

  describe '#allow_extra_options?' do
    include_examples 'should define predicate', :allow_extra_options?, false

    context 'when initialized with allow_extra_options: false' do
      let(:validator_options) { super().merge(allow_extra_options: false) }

      it { expect(validator.allow_extra_options?).to be false }
    end

    context 'when initialized with allow_extra_options: true' do
      let(:validator_options) { super().merge(allow_extra_options: true) }

      it { expect(validator.allow_extra_options?).to be true }
    end
  end

  describe '#call' do
    let(:component)         { Spec::ExampleComponent.new }
    let(:component_options) { {} }

    define_method :component_name do
      Spec::ExampleComponent.name
    end

    define_method :defined_options do
      validator.options
    end

    define_method :validate_options do
      validator.call(component:, value: component_options)
    end

    example_class 'Spec::ExampleComponent' do |klass|
      klass.include Plumbum::Consumer
      klass.include Librum::Components::Options::ValidationHelpers

      klass.provider Librum::Components.provider

      klass.dependency :configuration, optional: true
    end

    it 'should define the method' do
      expect(validator)
        .to respond_to(:call)
        .with(0).arguments
        .and_keywords(:component, :value)
    end

    include_deferred 'should validate the component options'

    context 'when initialized with allow_extra_options: true' do
      let(:validator_options) { super().merge(allow_extra_options: true) }
      let(:component_options) do
        {
          invalid_color:      '#ff3366',
          invalid_decoration: 'underline'
        }
      end

      it { expect { validate_options }.not_to raise_error }
    end

    wrap_deferred 'when initialized with options' do
      include_deferred 'should validate the component options'

      context 'when initialized with allow_extra_options: true' do
        let(:validator_options) { super().merge(allow_extra_options: true) }
        let(:component_options) do
          {
            invalid_color:      '#ff3366',
            invalid_decoration: 'underline'
          }
        end

        it { expect { validate_options }.not_to raise_error }
      end
    end

    context 'with an option with validate: true' do
      let(:raw_options) do
        { license: { validate: true } }
      end
      let(:error_message) { /undefined method 'validate_license'/ }

      it 'should raise an exception' do
        expect { validate_options }
          .to raise_error NoMethodError, error_message
      end

      context 'when the component defines the validation method' do
        before(:example) do
          Spec::ExampleComponent.define_method(:validate_license) \
          do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { validate_options }
              .not_to raise_error
          end
        end
      end
    end

    context 'with an option with validate: :array' do
      let(:raw_options) do
        { variants: { validate: :array } }
      end

      include_deferred 'should validate that option is a valid array',
        :variants
    end

    context 'with an option with validate: { array: true }' do
      let(:raw_options) do
        { variants: { validate: { array: true } } }
      end

      include_deferred 'should validate that option is a valid array',
        :variants
    end

    context 'with an option with validate: :array and item validations' do
      let(:raw_options) do
        {
          stir_directions: {
            validate: {
              array: { inclusion: %w[deosil widdershins] }
            }
          }
        }
      end

      include_deferred 'should validate that option is a valid array',
        :stir_directions,
        invalid_item: 'clockwise',
        item_message: 'is not included in the list',
        valid_items:  %w[deosil deosil widdershins deosil]
    end

    context 'with an option with validate: :color' do
      let(:raw_options) do
        { text_color: { validate: :color } }
      end

      include_deferred 'with configuration',
        colors: %i[red orange yellow green blue indigo violet]

      include_deferred 'should validate that option is a valid color',
        :text_color
    end

    context 'with an option with validate: :component' do
      let(:raw_options) do
        { widget: { validate: :component } }
      end

      include_deferred 'should validate that option is a valid component',
        :widget
    end

    context 'with an option with validate: :icon' do
      let(:raw_options) do
        { spinner_icon: { validate: :icon } }
      end

      include_deferred 'should validate that option is a valid icon',
        :spinner_icon
    end

    context 'with an option with validate: :inclusion' do
      let(:raw_options) do
        { size: { validate: { inclusion: %w[small medium large] } } }
      end

      include_deferred 'should validate the inclusion of option',
        :size,
        expected: %w[small medium large]
    end

    context 'with an option with validate: :name' do
      let(:raw_options) do
        { label: { validate: :name } }
      end

      include_deferred 'should validate that option is a valid name', :label
    end

    context 'with an option with validate: :presence' do
      let(:raw_options) do
        { disclaimer: { validate: :presence } }
      end

      include_deferred 'should validate the presence of option',
        :disclaimer,
        string: true
    end

    context 'with an option with validate: a custom method' do
      let(:raw_options) do
        { license: { validate: :warranty } }
      end
      let(:error_message) { /undefined method 'validate_warranty'/ }

      it 'should raise an exception' do
        expect { validate_options }.to raise_error NoMethodError, error_message
      end

      context 'when the component defines the validation method' do
        before(:example) do
          Spec::ExampleComponent.define_method(:validate_warranty) \
          do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { validate_options }.not_to raise_error
          end
        end
      end
    end

    context 'with an option with validate: a Class' do
      let(:raw_options) do
        { rate_limit: { validate: Integer } }
      end

      include_deferred 'should validate the type of option',
        :rate_limit,
        expected: Integer
    end

    context 'with an option with validate: a Proc' do
      let(:validation_proc) do
        lambda do |value|
          next if /\A#\h{6}\z/.match?(value)

          'option is not a valid color'
        end
      end
      let(:raw_options) do
        { text_color: { validate: validation_proc } }
      end

      context 'when initialized with an invalid value' do
        let(:component_options) { super().merge(text_color: 'whatever') }
        let(:error_message)     { 'option is not a valid color' }

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              error_message
            )
        end
      end

      context 'when initialized with a valid value' do
        let(:component_options) do
          super().merge(text_color: '#ff3366')
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end

      context 'when the validator accepts a name parameter' do
        let(:validation_proc) do
          lambda do |value, as: 'option'|
            next if /\A#\h{6}\z/.match?(value)

            "#{as} is not a valid color"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(text_color: 'whatever') }
          let(:error_message)     { 'text_color is not a valid color' }

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                error_message
              )
          end
        end
      end

      context 'when the validator requires a name parameter' do
        let(:validation_proc) do
          lambda do |value, as:|
            next if /\A#\h{6}\z/.match?(value)

            "#{as} is not a valid color"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(text_color: 'whatever') }
          let(:error_message)     { 'text_color is not a valid color' }

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                error_message
              )
          end
        end
      end
    end

    context 'with an option with multiple validations' do
      let(:raw_options) do
        {
          password: {
            validate: {
              instance_of: String,
              matches:     /12345/,
              secret:      true
            }
          }
        }
      end

      before(:example) do
        Spec::ExampleComponent.define_method :validate_secret do |value, as:|
          return if value == '12345'

          "#{as} should match the password on your luggage"
        end
      end

      include_deferred 'should validate the type of option',
        :password,
        expected: String

      include_deferred 'should validate the format of option',
        :password,
        expected:      /12345/,
        invalid_value: '23456'

      context 'when initialized with an invalid value' do
        let(:component_options) { super().merge(password: 'whatever') }
        let(:error_message) do
          'password should match the password on your luggage'
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      context 'when initialized with a valid value' do
        let(:component_options) do
          super().merge(password: '12345')
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end
    end

    context 'with a required option' do
      let(:raw_options) do
        { disclaimer: { required: true } }
      end

      include_deferred 'should validate the presence of option',
        :disclaimer,
        string: true
    end

    context 'with a required option with validate: true' do
      let(:raw_options) do
        {
          license: {
            required: true,
            validate: true
          }
        }
      end

      include_deferred 'should validate the presence of option',
        :license,
        string: true

      context 'when the component defines the validation method' do
        before(:example) do
          Spec::ExampleComponent.define_method(:validate_license) \
          do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { validate_options }
              .not_to raise_error
          end
        end
      end
    end

    context 'with a required option with validate: :presence' do
      let(:raw_options) do
        {
          disclaimer: {
            required: true,
            validate: :presence
          }
        }
      end

      include_deferred 'should validate the presence of option',
        :disclaimer,
        string: true
    end

    context 'with a required option with validate: a custom method' do
      let(:raw_options) do
        {
          license: {
            required: true,
            validate: :warranty
          }
        }
      end

      include_deferred 'should validate the presence of option',
        :license,
        string: true

      context 'when the component defines the validation method' do
        before(:example) do
          Spec::ExampleComponent.define_method(:validate_warranty) \
          do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { validate_options }
              .not_to raise_error
          end
        end
      end
    end

    context 'with a required option with validate: a Class' do
      let(:raw_options) do
        {
          rate_limit: {
            required: true,
            validate: Integer
          }
        }
      end

      include_deferred 'should validate the presence of option',
        :rate_limit

      include_deferred 'should validate the type of option',
        :rate_limit,
        expected: Integer,
        required: true
    end

    context 'with a required option with validate: a Proc' do
      let(:validation_proc) do
        lambda do |value|
          next if /\A#\h{6}\z/.match?(value)

          'option is not a valid color'
        end
      end
      let(:raw_options) do
        {
          text_color: {
            required: true,
            validate: validation_proc
          }
        }
      end

      include_deferred 'should validate the presence of option',
        :text_color

      context 'when initialized with an invalid value' do
        let(:component_options) { super().merge(text_color: 'whatever') }
        let(:error_message)     { 'option is not a valid color' }

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              error_message
            )
        end
      end

      context 'when initialized with a valid value' do
        let(:component_options) do
          super().merge(text_color: '#ff3366')
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end
    end

    context 'with a required option with multiple validations' do
      let(:raw_options) do
        {
          password: {
            required: true,
            validate: {
              instance_of: String,
              matches:     /12345/,
              secret:      true
            }
          }
        }
      end

      before(:example) do
        Spec::ExampleComponent.define_method :validate_secret do |value, as:|
          return if value == '12345'

          "#{as} should match the password on your luggage"
        end
      end

      include_deferred 'should validate the presence of option', :password

      include_deferred 'should validate the type of option',
        :password,
        expected: String,
        required: true

      include_deferred 'should validate the format of option',
        :password,
        expected:      /12345/,
        invalid_value: '23456'

      context 'when initialized with an invalid value' do
        let(:component_options) { super().merge(password: 'whatever') }
        let(:error_message) do
          'password should match the password on your luggage'
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      context 'when initialized with a valid value' do
        let(:component_options) do
          super().merge(password: '12345')
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, {}

    wrap_deferred 'when initialized with options' do
      let(:expected_options) do
        tools.hsh.convert_keys_to_strings(options)
      end

      it { expect(validator.options).to be == expected_options }
    end
  end
end
