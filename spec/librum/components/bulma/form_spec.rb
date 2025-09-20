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
    end
  end
end
