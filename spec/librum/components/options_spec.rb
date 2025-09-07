# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Options do
  include Librum::Components::RSpec::Deferred::ConfigurationExamples
  include Librum::Components::RSpec::Deferred::OptionsExamples

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

  describe '.new' do
    include_deferred 'should validate the component options'

    context 'when the component allows extra options' do
      before(:example) { described_class.allow_extra_options }

      describe 'with extra component options' do
        let(:component_options) do
          {
            invalid_color:      '#ff3366',
            invalid_decoration: 'underline'
          }
        end

        it 'should not raise an exception' do
          expect { described_class.new(**component_options) }
            .not_to raise_error
        end
      end
    end

    wrap_deferred 'when the component defines options' do
      include_deferred 'should validate the component options'

      context 'when the component allows extra options' do
        before(:example) { described_class.allow_extra_options }

        describe 'with extra component options' do
          let(:component_options) do
            {
              invalid_color:      '#ff3366',
              invalid_decoration: 'underline'
            }
          end

          it 'should not raise an exception' do
            expect { described_class.new(**component_options) }
              .not_to raise_error
          end
        end
      end
    end

    context 'with an option with default: value and validate: :presence' do
      before(:example) do
        described_class.option :access_level,
          default:  'public',
          validate: :presence
      end

      it 'should not raise an exception' do
        expect { described_class.new(**component_options) }
          .not_to raise_error
      end

      include_deferred 'should validate the presence of option',
        :access_level,
        string: true
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
            expect { described_class.new(**component_options) }
              .not_to raise_error
          end
        end
      end
    end
  end

  describe '.allow_extra_options' do
    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:allow_extra_options)
        .with(0).arguments
    end

    it 'should update the flag' do
      expect { described_class.allow_extra_options }
        .to change(described_class, :allow_extra_options?)
        .to be true
    end
  end

  describe '.allow_extra_options?' do
    it 'should define the predicate' do
      expect(described_class)
        .to define_predicate(:allow_extra_options?)
        .with_value(false)
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
