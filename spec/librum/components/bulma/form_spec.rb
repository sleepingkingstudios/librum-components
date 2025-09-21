# frozen_string_literal: true

require 'stannum/errors'

require 'librum/components/bulma/form'

RSpec.describe Librum::Components::Bulma::Form,
  framework: :bulma,
  type:      :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  deferred_context 'when the field component is defined' do
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
  end

  let(:result)            { Cuprum::Rails::Result.new }
  let(:required_keywords) { { result: } }

  include_deferred 'should define component option', :columns, value: 3

  describe '.new' do
    define_method :validate_options do
      described_class.new(**required_keywords, **component_options)
    end

    include_deferred 'should validate the type of option',
      :columns,
      allow_nil: true,
      expected:  Integer
  end

  describe '#buttons' do
    let(:options) { {} }
    let(:buttons) { component.buttons(**options) }

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

      context 'when initialized with columns: value' do
        let(:component_options) { super().merge(columns: 3) }

        describe 'with colspan: value' do
          let(:options) { super().merge(colspan: 2) }
          let(:expected_options) do
            super().except(:colspan).merge(class_name: 'cell is-col-span-2')
          end

          it { expect(buttons.options).to be == expected_options }
        end
      end
    end
  end

  describe '#call' do
    describe 'with action: value and columns: value' do
      let(:component_options) { super().merge(action: '/rockets', columns: 3) }
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-3-cols" action="/rockets" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <div class="grid"></div>
          </form>
        HTML
      end

      before(:example) do
        allow(component).to receive_messages( # rubocop:disable RSpec/SubjectStub
          form_authenticity_token:  '12345',
          protect_against_forgery?: true
        )
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with columns: value' do
      let(:component_options) { super().merge(columns: 3) }
      let(:snapshot) do
        <<~HTML
          <form class="fixed-grid has-3-cols">
            <div class="grid"></div>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with contents' do
        let(:contents) do
          component.content_tag('div') { 'Form Inputs' }
        end
        let(:component) do
          super().with_content(contents)
        end
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols">
              <div class="grid">
                <div>
                  Form Inputs
                </div>
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

            builder.input('rocket[name]', colspan: 2)

            builder.checkbox('rocket[refuel]')

            builder.text_area('rocket[description]', colspan: 3)
          end
        end
        let(:component) { super().build(&block) }
        let(:snapshot) do
          <<~HTML
            <form class="fixed-grid has-3-cols">
              <div class="grid">
                <h1>
                  Form Heading
                </h1>

                <div class="field cell is-col-span-2">
                  <label class="label">
                    Name
                  </label>

                  <div class="control">
                    <input name="rocket[name]" class="input" type="text">
                  </div>
                </div>

                <div class="field">
                  <div class="control">
                    <label class="checkbox">
                      <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

                      <input name="rocket[refuel]" type="checkbox" value="1">

                      <span class="ml-1">
                        Refuel
                      </span>
                    </label>
                  </div>
                </div>

                <div class="field cell is-col-span-3">
                  <label class="label">
                    Description
                  </label>

                  <div class="control">
                    <textarea name="rocket[description]" class="textarea"></textarea>
                  </div>
                </div>
              </div>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#checkbox' do
    let(:name)    { 'rocket[refuel]' }
    let(:options) { {} }
    let(:input)   { component.checkbox(name, **options) }

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'checkbox'
        }
          .merge(options)
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
          super().merge(
            color:   'danger',
            message: 'is out of fuel'
          )
        end

        it { expect(input.options).to be == expected_options }
      end

      context 'when initialized with columns: value' do
        let(:component_options) { super().merge(columns: 3) }

        describe 'with colspan: value' do
          let(:options) { super().merge(colspan: 2) }
          let(:expected_options) do
            super().except(:colspan).merge(class_name: 'cell is-col-span-2')
          end

          it { expect(input.options).to be == expected_options }
        end
      end
    end
  end

  describe '#input' do
    let(:name)    { 'rocket[name]' }
    let(:options) { {} }
    let(:input)   { component.input(name, **options) }

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'text'
        }
          .merge(options)
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
          super().merge(
            color:      'danger',
            icon_right: 'exclamation-triangle',
            message:    'is taken, is invalid'
          )
        end

        it { expect(input.options).to be == expected_options }
      end

      describe 'with type: checkbox' do
        let(:name)    { 'rocket[refuel]' }
        let(:options) { super().merge(type: 'checkbox') }

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
            super().merge(
              color:   'danger',
              message: 'is out of fuel'
            )
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
            super().merge(
              color:   'danger',
              message: 'is inactive'
            )
          end

          it { expect(input.options).to be == expected_options }
        end
      end

      describe 'with type: textarea' do
        let(:name)    { 'rocket[description]' }
        let(:options) { super().merge(type: 'textarea') }

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
            super().merge(
              color:   'danger',
              message: 'is empty'
            )
          end

          it { expect(input.options).to be == expected_options }
        end
      end

      context 'when initialized with columns: value' do
        let(:component_options) { super().merge(columns: 3) }

        describe 'with colspan: value' do
          let(:options) { super().merge(colspan: 2) }
          let(:expected_options) do
            super().except(:colspan).merge(class_name: 'cell is-col-span-2')
          end

          it { expect(input.options).to be == expected_options }
        end
      end
    end
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

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'select'
        }
          .merge(options)
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
          super().merge(
            color:   'danger',
            message: 'is inactive'
          )
        end

        it { expect(input.options).to be == expected_options }
      end

      context 'when initialized with columns: value' do
        let(:component_options) { super().merge(columns: 3) }

        describe 'with colspan: value' do
          let(:options) { super().merge(colspan: 2) }
          let(:expected_options) do
            super().except(:colspan).merge(class_name: 'cell is-col-span-2')
          end

          it { expect(input.options).to be == expected_options }
        end
      end
    end
  end

  describe '#text_area' do
    let(:name)    { 'rocket[description]' }
    let(:options) { {} }
    let(:input)   { component.text_area(name, **options) }

    wrap_deferred 'when the field component is defined' do
      let(:expected_options) do
        {
          name:,
          type: 'textarea'
        }
          .merge(options)
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
          super().merge(
            color:   'danger',
            message: 'is empty'
          )
        end

        it { expect(input.options).to be == expected_options }
      end

      context 'when initialized with columns: value' do
        let(:component_options) { super().merge(columns: 3) }

        describe 'with colspan: value' do
          let(:options) { super().merge(colspan: 2) }
          let(:expected_options) do
            super().except(:colspan).merge(class_name: 'cell is-col-span-2')
          end

          it { expect(input.options).to be == expected_options }
        end
      end
    end
  end
end
