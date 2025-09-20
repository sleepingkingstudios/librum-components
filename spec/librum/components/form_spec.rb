# frozen_string_literal: true

require 'stannum/errors'

require 'librum/components'

RSpec.describe Librum::Components::Form, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  deferred_examples 'should handle an undefined component' do
    context 'when the component is not defined' do
      let(:expected) do
        <<~HTML.strip
          <div style="color: #f00;">Missing Component Forms::Field</div>
        HTML
      end

      it { expect(build_input).to be_a ActiveSupport::SafeBuffer }

      it { expect(build_input).to be == expected }
    end

    context 'when the missing component is defined' do
      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::MissingComponent',
        Librum::Components::Base \
      do |klass|
        klass.option :name
      end

      it { expect(build_input).to be_a Spec::Components::MissingComponent }

      it { expect(build_input.name).to be == 'Forms::Field' }
    end
  end

  deferred_examples 'should require a valid name' do
    describe 'with nil' do
      let(:name) { nil }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'name'
        )
      end

      it 'should raise an exception' do
        expect { build_input }.to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:name) { Object.new.freeze }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.name',
          as: 'name'
        )
      end

      it 'should raise an exception' do
        expect { build_input }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:name) { '' }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'name'
        )
      end

      it 'should raise an exception' do
        expect { build_input }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Symbol' do
      let(:name) { :'' }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'name'
        )
      end

      it 'should raise an exception' do
        expect { build_input }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  let(:result)            { Cuprum::Rails::Result.new }
  let(:required_keywords) { { result: } }

  include_deferred 'should be a view component',
    has_required_keywords: true

  include_deferred 'should define component option', :action

  include_deferred 'should define component option',
    :http_method,
    value: 'get'

  describe '.new' do
    define_method :validate_options do
      described_class.new(**required_keywords, **component_options)
    end

    include_deferred 'should validate the type of option',
      :action,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate that option is a valid http method',
      :http_method
  end

  describe '#checkbox' do
    let(:name)    { 'rocket[refuel]' }
    let(:options) { {} }
    let(:input)   { component.checkbox(name, **options) }

    define_method :build_input do
      component.checkbox(name, **options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:checkbox)
        .with(1).argument
        .and_any_keywords
    end

    include_deferred 'should require a valid name'

    include_deferred 'should handle an undefined component'

    context 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'checkbox'
        }
          .merge(options)
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::Forms::Field', Librum::Components::Base \
      do |klass| # rubocop:disable Style/SymbolProc
        klass.allow_extra_options
      end

      it { expect(input).to be_a Spec::Components::Forms::Field }

      it { expect(input.options).to be == expected_options }

      context 'when the result has a falsy value' do
        let(:result) do
          Cuprum::Result.new(
            value: {
              'rocket' => { 'refuel' => false }
            }
          )
        end

        it { expect(input.options).to be == expected_options }
      end

      context 'when the result has a truthy value' do
        let(:result) do
          Cuprum::Result.new(
            value: {
              'rocket' => { 'refuel' => true }
            }
          )
        end
        let(:expected_options) { super().merge(checked: true) }

        it { expect(input.options).to be == expected_options }
      end

      context 'when the result has errors' do
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['rocket']['refuel'].add('empty', message: 'is out of fuel')
          end
        end
        let(:result) do
          Cuprum::Result.new(error: Struct.new(:errors).new(errors))
        end
        let(:expected_options) do
          super().merge(message: 'is out of fuel')
        end

        it { expect(input.options).to be == expected_options }
      end

      describe 'with options' do
        let(:options) do
          super().merge(label: 'Refuel Rocket', required: true)
        end

        it { expect(input.options).to be == expected_options }
      end
    end
  end

  describe '#errors_for' do
    it { expect(component).to respond_to(:errors_for).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.name',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for(Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for('') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Symbol' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for(:'') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a non-matching String' do
      it { expect(component.errors_for('invalid')).to be == [] }
    end

    describe 'with a non-matching Symbol' do
      it { expect(component.errors_for(:invalid)).to be == [] }
    end

    context 'when the result has an error' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong.') }
      let(:result) { Cuprum::Result.new(error:) }

      describe 'with a non-matching String' do
        it { expect(component.errors_for('invalid')).to be == [] }
      end

      describe 'with a non-matching Symbol' do
        it { expect(component.errors_for(:invalid)).to be == [] }
      end
    end

    context 'when the result has an error with an errors object' do
      let(:errors) do
        Stannum::Errors.new.tap do |err|
          err['launch_site'].add('not_ready', message: 'is not ready')
          err['rocket']['name'].add('taken')
          err['rocket']['fuel']['amount'].add('empty',   message: 'is empty')
          err['rocket']['fuel']['amount'].add('invalid', message: 'is invalid')
        end
      end
      let(:error)  { Struct.new(:errors).new(errors) }
      let(:result) { Cuprum::Result.new(error:) }

      describe 'with a non-matching String' do
        it { expect(component.errors_for('invalid')).to be == [] }
      end

      describe 'with a non-matching Symbol' do
        it { expect(component.errors_for(:invalid)).to be == [] }
      end

      describe 'with a matching String' do
        let(:expected) { ['is not ready'] }

        it { expect(component.errors_for('launch_site')).to be == expected }
      end

      describe 'with a matching Symbol' do
        let(:expected) { ['is not ready'] }

        it { expect(component.errors_for(:launch_site)).to be == expected }
      end

      describe 'with a non-matching bracket-separated path' do
        it { expect(component.errors_for('rocket[manufacturer]')).to be == [] }
      end

      describe 'with a matching bracket-separated path' do
        let(:expected) { ['is empty', 'is invalid'] }

        it 'should find the nested errors' do
          expect(component.errors_for('rocket[fuel][amount]')).to be == expected
        end
      end

      describe 'with a non-matching dot-separated path' do
        it { expect(component.errors_for('rocket.manufacturer')).to be == [] }
      end

      describe 'with a matching dot-separated path' do
        let(:expected) { ['is empty', 'is invalid'] }

        it 'should find the nested errors' do
          expect(component.errors_for('rocket.fuel.amount')).to be == expected
        end
      end
    end
  end

  describe '#input' do
    let(:name)    { 'rocket[name]' }
    let(:options) { {} }
    let(:input)   { component.input(name, **options) }

    define_method :build_input do
      component.input(name, **options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:input)
        .with(1).argument
        .and_keywords(:type)
        .and_any_keywords
    end

    include_deferred 'should require a valid name'

    include_deferred 'should handle an undefined component'

    context 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'text'
        }
          .merge(options)
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::Forms::Field', Librum::Components::Base \
      do |klass| # rubocop:disable Style/SymbolProc
        klass.allow_extra_options
      end

      it { expect(input).to be_a Spec::Components::Forms::Field }

      it { expect(input.options).to be == expected_options }

      context 'when the result has a value' do
        let(:result) do
          Cuprum::Result.new(
            value: {
              'rocket' => { 'name' => 'Hellhound IV' }
            }
          )
        end
        let(:expected_options) { super().merge(value: 'Hellhound IV') }

        it { expect(input.options).to be == expected_options }
      end

      context 'when the result has errors' do
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['rocket']['name'].add('taken',   message: 'is taken')
            err['rocket']['name'].add('invalid', message: 'is invalid')
          end
        end
        let(:result) do
          Cuprum::Result.new(error: Struct.new(:errors).new(errors))
        end
        let(:expected_options) do
          super().merge(message: 'is taken, is invalid')
        end

        it { expect(input.options).to be == expected_options }
      end

      describe 'with options' do
        let(:options) do
          super().merge(placeholder: 'Name Your Rocket', required: true)
        end

        it { expect(input.options).to be == expected_options }
      end

      describe 'with type: checkbox' do
        let(:name)    { 'rocket[refuel]' }
        let(:options) { super().merge(type: 'checkbox') }

        it { expect(input.options).to be == expected_options }

        context 'when the result has a falsy value' do
          let(:result) do
            Cuprum::Result.new(
              value: {
                'rocket' => { 'refuel' => false }
              }
            )
          end

          it { expect(input.options).to be == expected_options }
        end

        context 'when the result has a truthy value' do
          let(:result) do
            Cuprum::Result.new(
              value: {
                'rocket' => { 'refuel' => true }
              }
            )
          end
          let(:expected_options) { super().merge(checked: true) }

          it { expect(input.options).to be == expected_options }
        end

        context 'when the result has errors' do
          let(:errors) do
            Stannum::Errors.new.tap do |err|
              err['rocket']['refuel'].add('empty', message: 'is out of fuel')
            end
          end
          let(:result) do
            Cuprum::Result.new(error: Struct.new(:errors).new(errors))
          end
          let(:expected_options) do
            super().merge(message: 'is out of fuel')
          end

          it { expect(input.options).to be == expected_options }
        end

        describe 'with options' do
          let(:options) do
            super().merge(label: 'Refuel Rocket', required: true)
          end

          it { expect(input.options).to be == expected_options }
        end
      end

      describe 'with type: select' do
        let(:name) { 'rocket[space_program]' }
        let(:values) do
          [
            { label: 'Avalon Heavy Industries',  value: 'ahi' },
            { label: 'Morningstar Technologies', value: 'mst' }
          ]
        end
        let(:options) { super().merge(type: 'select', values:) }

        it { expect(input.options).to be == expected_options }

        context 'when the result has a value' do
          let(:result) do
            Cuprum::Result.new(
              value: {
                'rocket' => { 'space_program' => 'mst' }
              }
            )
          end
          let(:expected_options) { super().merge(value: 'mst') }

          it { expect(input.options).to be == expected_options }
        end

        context 'when the result has errors' do
          let(:errors) do
            Stannum::Errors.new.tap do |err|
              err['rocket']['space_program']
                .add('inactive', message: 'is inactive')
            end
          end
          let(:result) do
            Cuprum::Result.new(error: Struct.new(:errors).new(errors))
          end
          let(:expected_options) do
            super().merge(message: 'is inactive')
          end

          it { expect(input.options).to be == expected_options }
        end

        describe 'with options' do
          let(:options) do
            super().merge(placeholder: 'Select Space Program', required: true)
          end

          it { expect(input.options).to be == expected_options }
        end
      end

      describe 'with type: text_area' do
        let(:name)    { 'rocket[description]' }
        let(:options) { super().merge(type: 'text_area') }

        it { expect(input.options).to be == expected_options }

        context 'when the result has a value' do
          let(:result) do
            Cuprum::Result.new(
              value: {
                'rocket' => { 'description' => 'Majestic.' }
              }
            )
          end
          let(:expected_options) { super().merge(value: 'Majestic.') }

          it { expect(input.options).to be == expected_options }
        end

        context 'when the result has errors' do
          let(:errors) do
            Stannum::Errors.new.tap do |err|
              err['rocket']['description'].add('empty', message: 'is empty')
            end
          end
          let(:result) do
            Cuprum::Result.new(error: Struct.new(:errors).new(errors))
          end
          let(:expected_options) do
            super().merge(message: 'is empty')
          end

          it { expect(input.options).to be == expected_options }
        end

        describe 'with options' do
          let(:options) do
            super().merge(placeholder: 'Describe Your Rocket', required: true)
          end

          it { expect(input.options).to be == expected_options }
        end
      end
    end
  end

  describe '#result' do
    include_examples 'should define reader', :result, -> { result }
  end

  describe '#select' do
    let(:name) { 'rocket[space_program]' }
    let(:values) do
      [
        { label: 'Avalon Heavy Industries',  value: 'ahi' },
        { label: 'Morningstar Technologies', value: 'mst' }
      ]
    end
    let(:options) { { values: } }
    let(:input)   { component.select(name, **options) }

    define_method :build_input do
      component.select(name, **options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:select)
        .with(1).argument
        .and_keywords(:values)
        .and_any_keywords
    end

    include_deferred 'should require a valid name'

    include_deferred 'should handle an undefined component'

    context 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'select'
        }
          .merge(options)
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::Forms::Field', Librum::Components::Base \
      do |klass| # rubocop:disable Style/SymbolProc
        klass.allow_extra_options
      end

      it { expect(input).to be_a Spec::Components::Forms::Field }

      it { expect(input.options).to be == expected_options }

      context 'when the result has a value' do
        let(:result) do
          Cuprum::Result.new(
            value: {
              'rocket' => { 'space_program' => 'mst' }
            }
          )
        end
        let(:expected_options) { super().merge(value: 'mst') }

        it { expect(input.options).to be == expected_options }
      end

      context 'when the result has errors' do
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['rocket']['space_program']
              .add('inactive', message: 'is inactive')
          end
        end
        let(:result) do
          Cuprum::Result.new(error: Struct.new(:errors).new(errors))
        end
        let(:expected_options) do
          super().merge(message: 'is inactive')
        end

        it { expect(input.options).to be == expected_options }
      end

      describe 'with options' do
        let(:options) do
          super().merge(placeholder: 'Select Space Program', required: true)
        end

        it { expect(input.options).to be == expected_options }
      end
    end
  end

  describe '#text_area' do
    let(:name)    { 'rocket[description]' }
    let(:options) { {} }
    let(:input)   { component.text_area(name, **options) }

    define_method :build_input do
      component.text_area(name, **options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:text_area)
        .with(1).argument
        .and_any_keywords
    end

    it 'should alias the method' do
      expect(component).to have_aliased_method(:text_area).as(:textarea)
    end

    include_deferred 'should require a valid name'

    include_deferred 'should handle an undefined component'

    context 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'textarea'
        }
          .merge(options)
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::Forms::Field', Librum::Components::Base \
      do |klass| # rubocop:disable Style/SymbolProc
        klass.allow_extra_options
      end

      it { expect(input).to be_a Spec::Components::Forms::Field }

      it { expect(input.options).to be == expected_options }

      context 'when the result has a value' do
        let(:result) do
          Cuprum::Result.new(
            value: {
              'rocket' => { 'description' => 'Majestic.' }
            }
          )
        end
        let(:expected_options) { super().merge(value: 'Majestic.') }

        it { expect(input.options).to be == expected_options }
      end

      context 'when the result has errors' do
        let(:errors) do
          Stannum::Errors.new.tap do |err|
            err['rocket']['description'].add('empty', message: 'is empty')
          end
        end
        let(:result) do
          Cuprum::Result.new(error: Struct.new(:errors).new(errors))
        end
        let(:expected_options) do
          super().merge(message: 'is empty')
        end

        it { expect(input.options).to be == expected_options }
      end

      describe 'with options' do
        let(:options) do
          super().merge(placeholder: 'Describe Your Rocket', required: true)
        end

        it { expect(input.options).to be == expected_options }
      end
    end
  end

  describe '#value_for' do
    it { expect(component).to respond_to(:value_for).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.name',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for(Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for('') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Symbol' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for(:'') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a non-matching String' do
      it { expect(component.value_for('invalid')).to be nil }
    end

    describe 'with a non-matching Symbol' do
      it { expect(component.value_for(:invalid)).to be nil }
    end

    context 'when the result has a value' do
      let(:value) do
        {
          'launch_site' => 'KSC',
          'rocket'      => {
            'name' => 'Imp VI',
            'fuel' => Struct.new(:amount).new('0.0')
          }
        }
      end
      let(:result) { Cuprum::Result.new(value:) }

      describe 'with a non-matching String' do
        it { expect(component.value_for('invalid')).to be nil }
      end

      describe 'with a non-matching Symbol' do
        it { expect(component.value_for(:invalid)).to be nil }
      end

      describe 'with a matching String' do
        it { expect(component.value_for('launch_site')).to be == 'KSC' }
      end

      describe 'with a matching Symbol' do
        it { expect(component.value_for(:launch_site)).to be == 'KSC' }
      end

      describe 'with a non-matching bracket-separated path' do
        it { expect(component.value_for('rocket[manufacturer]')).to be nil }
      end

      describe 'with a matching bracket-separated path' do
        it 'should find the nested value' do
          expect(component.value_for('rocket[fuel][amount]')).to be == '0.0'
        end
      end

      describe 'with a non-matching dot-separated path' do
        it { expect(component.value_for('rocket.manufacturer')).to be nil }
      end

      describe 'with a matching dot-separated path' do
        it 'should find the nested value' do
          expect(component.value_for('rocket.fuel.amount')).to be == '0.0'
        end
      end
    end
  end
end
