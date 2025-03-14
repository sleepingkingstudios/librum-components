# frozen_string_literal: true

require 'support/deferred'

module Spec::Support::Deferred
  module OptionsExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'when the component defines options' do
      before(:example) do
        described_class.option :label

        described_class.option :checked, boolean: true
      end
    end

    deferred_examples 'should define component option' \
    do |name, boolean: false, default: nil, value: 'value'|
      name = name.to_s
      name = name.sub(/\?\z/, '') if boolean

      let(:expected_value) do
        next super() if defined?(super())

        next false if boolean && default.nil?

        next default unless default.is_a?(Proc)

        instance_exec(&default)
      end

      it { expect(described_class.options.keys).to include name }

      if boolean
        include_examples 'should define predicate', name, -> { expected_value }

        context "when the component is initialized with #{name}: false" do
          let(:component_options) { super().merge(name.intern => false) }

          it { expect(component.send(:"#{name}?")).to be false }
        end

        context "when the component is initialized with #{name}: true" do
          let(:component_options) { super().merge(name.intern => true) }

          it { expect(component.send(:"#{name}?")).to be true }
        end
      else
        include_examples 'should define reader', name, -> { expected_value }

        context "when the component is initialized with #{name}: value" do
          let(:component_options) { super().merge(name.intern => value) }

          it { expect(component.send(name)).to be == value }
        end
      end
    end

    deferred_examples 'should validate the class_name option' do
      context 'when initialized with class_name: an Object' do
        let(:component_options) do
          super().merge(class_name: Object.new.freeze)
        end
        let(:error_message) do
          'class_name must be a String or Array of Strings'
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      context 'when initialized with class_name: an Array with an Object' do
        let(:component_options) do
          super().merge(class_name: [Object.new.freeze])
        end
        let(:error_message) do
          'class_name must be a String or Array of Strings'
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end

    deferred_examples 'should validate the component options' do
      describe 'with extra component options' do
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
          'invalid_color is not a valid option, invalid_decoration is not a ' \
            'valid option'
        end
        let(:valid_options_message) do
          if described_class.options.empty?
            "#{described_class.name} does not define any valid options"
          else
            "valid options for #{described_class.name} are #{valid_options}"
          end
        end

        define_method :tools do
          SleepingKingStudios::Tools::Toolbelt.instance
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              include(error_message).and(include(valid_options_message))
            )
        end
      end
    end

    deferred_examples 'should validate the color of option' do |option_name|
      context "when :#{option_name} is an invalid color" do
        let(:component_options) do
          super().merge(option_name.intern => 'octarine')
        end
        let(:error_message) do
          "#{option_name} is not a valid color name"
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

    deferred_examples 'should validate the format of option' \
    do |option_name, expected:, invalid_value:|
      context "when :#{option_name} does not match the format" do
        let(:component_options) do
          super().merge(option_name.intern => invalid_value)
        end
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.matches_regexp',
            as:      option_name,
            pattern: expected.inspect
          )
        end

        define_method :tools do
          SleepingKingStudios::Tools::Toolbelt.instance
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end

    deferred_examples 'should validate the presence of option' \
    do |option_name, string: false|
      context "when :#{option_name} is nil" do
        let(:component_options) do
          super().merge(option_name.intern => nil)
        end
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.presence',
            as: option_name
          )
        end

        define_method :tools do
          SleepingKingStudios::Tools::Toolbelt.instance
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      if string
        context "when :#{option_name} is an empty String" do
          let(:component_options) do
            super().merge(option_name.intern => '')
          end
          let(:error_message) do
            tools.assertions.error_message_for(
              'sleeping_king_studios.tools.assertions.presence',
              as: option_name
            )
          end

          define_method :tools do
            SleepingKingStudios::Tools::Toolbelt.instance
          end

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                include(error_message)
              )
          end
        end
      end
    end

    deferred_examples 'should validate the type of option' \
    do |option_name, expected:, required: false|
      unless required
        context "when :#{option_name} is nil" do
          let(:component_options) do
            super().merge(option_name.intern => nil)
          end
          let(:error_message) do
            tools.assertions.error_message_for(
              'sleeping_king_studios.tools.assertions.instance_of',
              as:       option_name,
              expected: expected
            )
          end

          define_method :tools do
            SleepingKingStudios::Tools::Toolbelt.instance
          end

          it 'should raise an exception' do
            expect { described_class.new(**component_options) }
              .to raise_error(
                described_class::InvalidOptionsError,
                include(error_message)
              )
          end
        end
      end

      context "when :#{option_name} is an Object" do
        let(:component_options) do
          super().merge(option_name.intern => Object.new.freeze)
        end
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:       option_name,
            expected: expected
          )
        end

        define_method :tools do
          SleepingKingStudios::Tools::Toolbelt.instance
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error(
              described_class::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end
  end
end
