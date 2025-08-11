# frozen_string_literal: true

require 'support/deferred'

module Spec::Support::Deferred
  module AbstractExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_examples 'should check for duplicate options' do
      include RSpec::SleepingKingStudios::Deferred::Dependencies

      depends_on :name,         'the name of the defined option'
      depends_on :meta_options, 'the options passed to .option()'

      wrap_deferred 'when the option is defined' do
        let(:error_message) do
          option_name = "#{name}#{'?' if meta_options[:boolean]}"

          "unable to define option ##{option_name} - the option is already " \
            "defined on #{described_class.name}"
        end

        it 'should raise an exception' do
          expect { described_class.option(name, **meta_options) }
            .to raise_error(
              Librum::Components::Options::DuplicateOptionError,
              error_message
            )
        end
      end
    end

    deferred_examples 'should define the configured option' do
      include RSpec::SleepingKingStudios::Deferred::Dependencies

      depends_on :name,         'the name of the defined option'
      depends_on :meta_options, 'the options passed to .option()'

      describe 'with boolean: true' do
        let(:meta_options) { super().merge(boolean: true) }

        it 'should return the name of the generated method' do
          expect(described_class.option(name, **meta_options))
            .to be :"#{name}?"
        end

        include_deferred 'should check for duplicate options'

        wrap_deferred 'when the option is defined' do
          include_deferred 'should define component option',
            'example_option?',
            boolean: true,
            default: false
        end

        describe 'with default: a Proc' do
          let(:meta_options)     { super().merge(default: -> { 'value' }) }
          let(:expected_default) { 'value' }

          wrap_deferred 'when the option is defined' do
            include_deferred 'should define component option',
              'example_option',
              boolean: true,
              default: -> { expected_default }
          end
        end

        describe 'with default: value' do
          let(:meta_options)     { super().merge(default: 'value') }
          let(:expected_default) { 'value' }

          wrap_deferred 'when the option is defined' do
            include_deferred 'should define component option',
              'example_option',
              boolean: true,
              default: 'value'
          end
        end
      end

      describe 'with default: a Proc' do
        let(:meta_options)     { super().merge(default: -> { 'value' }) }
        let(:expected_default) { 'value' }

        wrap_deferred 'when the option is defined' do
          include_deferred 'should define component option',
            'example_option',
            default: -> { expected_default }
        end
      end

      describe 'with default: value' do
        let(:meta_options)     { super().merge(default: 'value') }
        let(:expected_default) { 'value' }

        wrap_deferred 'when the option is defined' do
          include_deferred 'should define component option',
            'example_option',
            default: 'value'
        end
      end

      describe 'with name: a string' do
        it 'should return the name of the generated method' do
          expect(described_class.option(name, **meta_options)).to be name.intern
        end

        include_deferred 'should check for duplicate options'

        wrap_deferred 'when the option is defined' do
          include_deferred 'should define component option', 'example_option'
        end
      end

      describe 'with name: a symbol' do
        let(:name) { super().intern }

        it 'should return the name of the generated method' do
          expect(described_class.option(name, **meta_options)).to be name
        end

        include_deferred 'should check for duplicate options'

        wrap_deferred 'when the option is defined' do
          include_deferred 'should define component option', 'example_option'
        end
      end
    end
  end
end
