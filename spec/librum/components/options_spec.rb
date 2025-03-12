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

  describe '.new' do
    include_deferred 'should validate the component options'

    wrap_deferred 'when the component defines options' do
      include_deferred 'should validate the component options'
    end

    context 'with an option with validate: true' do
      let(:error_message) { /undefined method 'validate_license'/ }

      before(:example) do
        described_class.option :license, validate: true
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error NoMethodError, error_message
      end

      context 'when the class defines the validation method' do
        before(:example) do
          described_class.define_method(:validate_license) do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { described_class.new(**component_options) }
              .not_to raise_error
          end
        end
      end
    end

    context 'with an option with validate: :presence' do
      before(:example) do
        described_class.option :disclaimer, validate: :presence
      end

      include_deferred 'should validate the presence of option',
        :disclaimer,
        string: true
    end

    context 'with an option with validate: a custom method' do
      let(:error_message) { /undefined method 'validate_warranty'/ }

      before(:example) do
        described_class.option :license, validate: :warranty
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error NoMethodError, error_message
      end

      context 'when the class defines the validation method' do
        before(:example) do
          described_class.define_method(:validate_warranty) do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { described_class.new(**component_options) }
              .not_to raise_error
          end
        end
      end
    end

    context 'with an option with validate: a Class' do
      before(:example) do
        described_class.option :rate_limit, validate: Integer
      end

      include_deferred 'should validate the type of option',
        :rate_limit,
        expected: Integer
    end

    context 'with an option with validate: a Proc' do
      let(:validator) do
        lambda do |value|
          next if /\A#\h{6}\z/.match?(value)

          'option is not a valid color'
        end
      end

      before(:example) do
        described_class.option :text_color, validate: validator
      end

      context 'when initialized with an invalid value' do
        let(:component_options) { super().merge(text_color: 'whatever') }
        let(:error_message)     { 'option is not a valid color' }

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              error_message
            )
        end
      end

      context 'when initialized with a valid value' do
        let(:component_options) do
          super().merge(text_color: '#ff3366')
        end

        it 'should not raise an exception' do
          expect { described_class.new(**component_options) }
            .not_to raise_error
        end
      end

      context 'when the validator accepts a name parameter' do
        let(:validator) do
          lambda do |value, as: 'option'|
            next if /\A#\h{6}\z/.match?(value)

            "#{as} is not a valid color"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(text_color: 'whatever') }
          let(:error_message)     { 'text_color is not a valid color' }

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                error_message
              )
          end
        end
      end

      context 'when the validator requires a name parameter' do
        let(:validator) do
          lambda do |value, as:|
            next if /\A#\h{6}\z/.match?(value)

            "#{as} is not a valid color"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(text_color: 'whatever') }
          let(:error_message)     { 'text_color is not a valid color' }

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

    context 'with a required option' do
      before(:example) { described_class.option :disclaimer, required: true }

      include_deferred 'should validate the presence of option',
        :disclaimer,
        string: true
    end

    context 'with a required option with validate: true' do
      before(:example) do
        described_class.option :license, required: true, validate: true
      end

      include_deferred 'should validate the presence of option',
        :license,
        string: true

      context 'when the class defines the validation method' do
        before(:example) do
          described_class.define_method(:validate_license) do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { described_class.new(**component_options) }
              .not_to raise_error
          end
        end
      end
    end

    context 'with a required option with validate: :presence' do
      before(:example) do
        described_class.option :disclaimer,
          required: true,
          validate: :presence
      end

      include_deferred 'should validate the presence of option',
        :disclaimer,
        string: true
    end

    context 'with a required option with validate: a custom method' do
      before(:example) do
        described_class.option :license, required: true, validate: :warranty
      end

      include_deferred 'should validate the presence of option',
        :license,
        string: true

      context 'when the class defines the validation method' do
        before(:example) do
          described_class.define_method(:validate_warranty) do |value, as:|
            next if value.include?('WITHOUT WARRANTY OF ANY KIND')

            "#{as} is not a valid license"
          end
        end

        context 'when initialized with an invalid value' do
          let(:component_options) { super().merge(license: 'whatever') }
          let(:error_message)     { 'license is not a valid license' }

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                error_message
              )
          end
        end

        context 'when initialized with a valid value' do
          let(:component_options) do
            super().merge(license: 'ISSUED WITHOUT WARRANTY OF ANY KIND')
          end

          it 'should not raise an exception' do
            expect { described_class.new(**component_options) }
              .not_to raise_error
          end
        end
      end
    end

    context 'with a required option with validate: a Class' do
      before(:example) do
        described_class.option :rate_limit, required: true, validate: Integer
      end

      include_deferred 'should validate the presence of option',
        :rate_limit

      include_deferred 'should validate the type of option',
        :rate_limit,
        expected: Integer,
        required: true
    end

    context 'with a required option with validate: a Proc' do
      let(:validator) do
        lambda do |value|
          next if /\A#\h{6}\z/.match?(value)

          'option is not a valid color'
        end
      end

      before(:example) do
        described_class.option :text_color, required: true, validate: validator
      end

      include_deferred 'should validate the presence of option',
        :text_color

      context 'when initialized with an invalid value' do
        let(:component_options) { super().merge(text_color: 'whatever') }
        let(:error_message)     { 'option is not a valid color' }

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              error_message
            )
        end
      end

      context 'when initialized with a valid value' do
        let(:component_options) do
          super().merge(text_color: '#ff3366')
        end

        it 'should not raise an exception' do
          expect { described_class.new(**component_options) }
            .not_to raise_error
        end
      end
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
        .and_keywords(:boolean, :default, :required, :validate)
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
