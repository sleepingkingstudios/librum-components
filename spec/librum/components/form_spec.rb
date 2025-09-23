# frozen_string_literal: true

require 'stannum/errors'

require 'librum/components'

RSpec.describe Librum::Components::Form, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  deferred_context 'when the field component is defined' do
    prepend_before(:example) do
      stub_provider(
        Librum::Components.provider,
        :components,
        Spec::Components
      )
    end

    example_class 'Spec::Components::Forms::Field', Librum::Components::Base \
    do |klass|
      klass.allow_extra_options

      klass.option :name
      klass.option :type

      klass.define_method :call do
        %(<input name="#{name}" type="#{type}" />).html_safe # rubocop:disable Rails/OutputSafety
      end
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
        expect { build_component }.to raise_error ArgumentError, error_message
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
        expect { build_component }
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
        expect { build_component }
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
        expect { build_component }
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

  include_deferred 'should define component option', :class_name

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

    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid http method',
      :http_method
  end

  describe '#build' do
    let(:block) do
      ->(_) {}
    end
    let(:builder) do
      be_a(described_class::Builder).and have_attributes(form: component)
    end

    it { expect(component).to respond_to(:build).with(0).arguments.and_a_block }

    it { expect(component.build(&block)).to be component }

    it 'should create and yield a builder' do
      expect { |block| component.build(&block) }.to yield_with_args(builder)
    end
  end

  describe '#buttons' do
    let(:options) { {} }
    let(:buttons) { component.buttons(**options) }

    define_method :build_component do
      component.buttons(**options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:buttons)
        .with_any_keywords
    end

    include_deferred 'should return a missing component', 'Forms::Buttons'

    context 'when the buttons component is defined' do
      let(:expected_options) { options }

      prepend_before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::Forms::Buttons',
        Librum::Components::Base \
      do |klass|
        klass.allow_extra_options

        klass.option :text
      end

      it { expect(buttons).to be_a Spec::Components::Forms::Buttons }

      it { expect(buttons.options).to be == expected_options }

      describe 'with options' do
        let(:options) do
          super().merge(color: 'danger', text: 'Launch Rocket')
        end

        it { expect(buttons.options).to be == expected_options }
      end
    end
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <form></form>
      HTML
    end

    before(:example) do
      allow(component).to receive_messages( # rubocop:disable RSpec/SubjectStub
        form_authenticity_token:  '12345',
        protect_against_forgery?: true
      )
    end

    include_deferred 'when the field component is defined'

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with action: value' do
      let(:component_options) { super().merge(action: '/rockets') }
      let(:snapshot) do
        <<~HTML
          <form action="/rockets" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with action: value and class_name: value' do
      let(:component_options) do
        super().merge(action: '/rockets', class_name: 'custom-class')
      end
      let(:snapshot) do
        <<~HTML
          <form class="custom-class" action="/rockets" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with action: value and http_method: value' do
      let(:component_options) do
        super().merge(action: '/rockets/imp-vi', http_method: 'patch')
      end
      let(:snapshot) do
        <<~HTML
          <form action="/rockets/imp-vi" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="_method" value="patch" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with action: value and contents' do
      let(:contents) do
        component.content_tag('div') { 'Form Inputs' }
      end
      let(:component) do
        super().with_content(contents)
      end
      let(:component_options) { super().merge(action: '/rockets') }
      let(:snapshot) do
        <<~HTML
          <form action="/rockets" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <div>
              Form Inputs
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <form class="custom-class"></form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with contents' do
      let(:contents) do
        component.content_tag('div') { 'Form Inputs' }
      end
      let(:component) do
        super().with_content(contents)
      end
      let(:snapshot) do
        <<~HTML
          <form>
            <div>
              Form Inputs
            </div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with fields from a form builder' do
      let(:block) do
        lambda do |builder|
          builder.fields << component.content_tag('h1') { 'Form Heading' }

          builder.input('rocket[name]')

          builder.checkbox('rocket[refuel]')

          builder.text_area('rocket[description]')
        end
      end
      let(:component) { super().build(&block) }
      let(:snapshot) do
        <<~HTML
          <form>
            <h1>
              Form Heading
            </h1>

            <input name="rocket[name]" type="text">

            <input name="rocket[refuel]" type="checkbox">

            <input name="rocket[description]" type="textarea">
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#checkbox' do
    let(:name)    { 'rocket[refuel]' }
    let(:options) { {} }
    let(:input)   { component.checkbox(name, **options) }

    define_method :build_component do
      component.checkbox(name, **options)
    end

    it 'should define the method' do
      expect(component)
        .to respond_to(:checkbox)
        .with(1).argument
        .and_any_keywords
    end

    include_deferred 'should require a valid name'

    include_deferred 'should return a missing component', 'Forms::Field'

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'checkbox'
        }
          .merge(options)
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

    define_method :build_component do
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

    include_deferred 'should return a missing component', 'Forms::Field'

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'text'
        }
          .merge(options)
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

      describe 'with type: textarea' do
        let(:name)    { 'rocket[description]' }
        let(:options) { super().merge(type: 'textarea') }

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

    define_method :build_component do
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

    include_deferred 'should return a missing component', 'Forms::Field'

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'select'
        }
          .merge(options)
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

    define_method :build_component do
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

    include_deferred 'should return a missing component', 'Forms::Field'

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'textarea'
        }
          .merge(options)
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
