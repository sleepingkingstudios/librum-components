# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

require 'librum/components'

module Librum::Components::RSpec::Deferred
  # Deferred examples verifying component options.
  module OptionsExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    define_method :tools do
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    define_method :validate_options do
      next super() if defined?(super())

      described_class.new(**component_options)
    end

    deferred_context 'when the component defines options' do
      before(:example) do
        described_class.option :label

        described_class.option :checked, boolean: true
      end
    end

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
              Librum::Components::Errors::DuplicateOptionError,
              error_message
            )
        end
      end
    end

    # Deferred examples that validate an existing option for a component.
    deferred_examples 'should define component option' \
    do |name, boolean: false, default: nil, value: 'value'|
      name = name.to_s
      name = name.sub(/\?\z/, '') if boolean

      it { expect(described_class.options.keys).to include name }

      if boolean
        include_examples 'should define predicate',
          name,
          lambda {
            component_options.fetch(name.intern) do
              (default.is_a?(Proc) ? instance_exec(&default) : default) || false
            end
          }

        context "when the component is initialized with #{name}: false" do
          let(:component_options) { super().merge(name.intern => false) }

          it { expect(component.send(:"#{name}?")).to be false }
        end

        context "when the component is initialized with #{name}: true" do
          let(:component_options) { super().merge(name.intern => true) }

          it { expect(component.send(:"#{name}?")).to be true }
        end
      else
        include_examples 'should define reader',
          name,
          lambda {
            component_options.fetch(name.intern) do
              default.is_a?(Proc) ? instance_exec(&default) : default
            end
          }

        context "when the component is initialized with #{name}: value" do
          let(:component_options) { super().merge(name.intern => value) }

          it { expect(component.send(name)).to be == value }
        end
      end
    end

    # Deferred examples that validate defining a new option.
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
              Librum::Components::Errors::InvalidOptionsError,
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
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end

    deferred_examples 'should validate the component options' do
      describe 'with extra component options' do
        let(:required_keywords) do
          next super() if defined?(super())

          {}
        end
        let(:component_options) do
          required_keywords.merge(
            invalid_color:      '#ff3366',
            invalid_decoration: 'underline'
          )
        end
        let(:valid_options) do
          defined_options
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
          if defined_options.empty?
            "#{component_name} does not define any valid options"
          else
            "valid options for #{component_name} are #{valid_options}"
          end
        end

        define_method :component_name do
          next super() if defined?(super())

          described_class.name
        end

        define_method :defined_options do
          next super() if defined?(super())

          described_class.options
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message).and(include(valid_options_message))
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

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end

    deferred_examples 'should validate the inclusion of option' \
    do |option_name, expected:, invalid_value: '12345'|
      expected.each do |expected_value|
        context "when :#{option_name} is #{expected_value}" do
          let(:component_options) do
            super().merge(option_name.intern => expected_value)
          end

          it 'should not raise an exception' do
            expect { validate_options }.not_to raise_error
          end
        end
      end

      context "when :#{option_name} is invalid" do
        let(:component_options) do
          super().merge(option_name.intern => invalid_value)
        end
        let(:error_message) do
          "#{option_name} is not included in the list"
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end

    deferred_examples 'should validate the presence of option' \
    do |option_name, array: false, string: false|
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

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      if array
        context "when :#{option_name} is an empty Array" do
          let(:component_options) do
            super().merge(option_name.intern => [])
          end
          let(:error_message) do
            tools.assertions.error_message_for(
              'sleeping_king_studios.tools.assertions.presence',
              as: option_name
            )
          end

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                include(error_message)
              )
          end
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

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
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

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
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

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end

    deferred_examples 'should validate that option is a valid array' \
    do |option_name, invalid_item: '12345', item_message: nil, valid_items: nil|
      context "when :#{option_name} is an Object" do
        let(:component_options) do
          super().merge(option_name.intern => Object.new.freeze)
        end
        let(:error_message) do
          "#{option_name} is not an Array"
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      if valid_items
        context "when :#{option_name} is an Array with invalid items" do
          let(:component_options) do
            items = [valid_items.first, invalid_item, *valid_items[1..]]

            super().merge(option_name.intern => items)
          end
          let(:error_message) do
            "#{option_name} item 1 #{item_message}"
          end

          it 'should raise an exception' do
            expect { validate_options }
              .to raise_error(
                Librum::Components::Errors::InvalidOptionsError,
                include(error_message)
              )
          end
        end

        context "when :#{option_name} is an Array with valid items" do
          let(:component_options) do
            super().merge(option_name.intern => valid_items)
          end

          it 'should not raise an exception' do
            expect { validate_options }.not_to raise_error
          end
        end
      end
    end

    deferred_examples 'should validate that option is a valid color' \
    do |option_name|
      context "when :#{option_name} is an invalid color" do
        let(:component_options) do
          super().merge(option_name.intern => 'octarine')
        end
        let(:error_message) do
          "#{option_name} is not a valid color name"
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              error_message
            )
        end
      end
    end

    deferred_examples 'should validate that option is a valid component' \
    do |option_name|
      context "when :#{option_name} is an Object" do
        let(:component_options) do
          super().merge(option_name.intern => Object.new.freeze)
        end
        let(:error_message) do
          "#{option_name} is not a component or options Hash"
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      context "when :#{option_name} is parameters for a component" do
        let(:component_options) do
          super().merge(option_name.intern => {})
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end

      context "when :#{option_name} is a component" do
        let(:component_options) do
          value = Librum::Components::Icons::FontAwesome.new(
            family: 'fa-solid',
            icon:   'rainbow'
          )

          super().merge(option_name.intern => value)
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end
    end

    deferred_examples 'should validate that option is a valid icon' \
    do |option_name|
      context "when :#{option_name} is an Object" do
        let(:component_options) do
          super().merge(option_name.intern => Object.new.freeze)
        end
        let(:error_message) do
          "#{option_name} is not a valid icon"
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end

      context "when :#{option_name} is an icon name" do
        let(:component_options) do
          super().merge(option_name.intern => 'rainbow')
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end

      context "when :#{option_name} is parameters for an icon component" do
        let(:component_options) do
          super().merge(option_name.intern => { icon: 'rainbow' })
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end

      context "when :#{option_name} is an icon component" do
        let(:icon) do
          Librum::Components::Icons::FontAwesome.new(
            family: 'fa-solid',
            icon:   'rainbow'
          )
        end
        let(:component_options) do
          super().merge(option_name.intern => { icon: })
        end

        it 'should not raise an exception' do
          expect { validate_options }.not_to raise_error
        end
      end
    end

    deferred_examples 'should validate that option is a valid name' \
    do |option_name|
      context "when :#{option_name} is an Object" do
        let(:component_options) do
          super().merge(option_name.intern => Object.new.freeze)
        end
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.name',
            as: option_name
          )
        end

        it 'should raise an exception' do
          expect { validate_options }
            .to raise_error(
              Librum::Components::Errors::InvalidOptionsError,
              include(error_message)
            )
        end
      end
    end
  end
end
