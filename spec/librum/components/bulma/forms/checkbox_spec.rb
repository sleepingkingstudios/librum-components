# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::Checkbox,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :checked,
    boolean: true

  include_deferred 'should define component option',
    :disabled,
    boolean: true

  include_deferred 'should define component option', :id

  include_deferred 'should define component option', :label

  include_deferred 'should define component option', :name

  include_deferred 'should define component option',
    :required,
    boolean: true

  include_deferred 'should define component option', :value

  describe '.new' do
    include_deferred 'should validate the type of option',
      :id,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :value,
      allow_nil: true,
      expected:  String

    describe 'with label: an Object' do
      let(:component_options) { super().merge(label: Object.new.freeze) }
      let(:error_message) do
        'label is not a String or a component'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <label class="checkbox">
          <input autocomplete="off" type="hidden" value="0">

          <input type="checkbox" value="1">
        </label>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with checked: true' do
      let(:component_options) { super().merge(checked: true) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" checked="checked" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: true' do
      let(:component_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" disabled="disabled" value="0">

            <input type="checkbox" disabled="disabled" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:component_options) { super().merge(id: 'rocket_refuel') }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input id="rocket_refuel" type="checkbox" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: a String' do
      let(:label)             { 'Refuel Rocket' }
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" value="1">

            <span class="ml-1">
              Refuel Rocket
            </span>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: an HTML string' do
      let(:label) do
        '<span class="has-text-red">Refuel Rocket</span>'
      end
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" value="1">

            <span class="ml-1">
              Refuel Rocket
            </span>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: a safe HTML string' do
      let(:label) do
        '<span class="has-text-red">Refuel Rocket</span>'.html_safe
      end
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" value="1">

            <span class="has-text-red">
              Refuel Rocket
            </span>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with label: a component' do
      let(:label) do
        Librum::Components::Literal.new(
          '<span class="has-text-red">Refuel Rocket</span>'
        )
      end
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" value="1">

            <span class="has-text-red">
              Refuel Rocket
            </span>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with name: value' do
      let(:component_options) { super().merge(name: 'rocket[refuel]') }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

            <input name="rocket[refuel]" type="checkbox" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with required: true' do
      let(:component_options) { super().merge(required: true) }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" required="required" value="1">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:component_options) { super().merge(value: 'true') }
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" type="hidden" value="0">

            <input type="checkbox" value="true">
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          checked:  true,
          id:       'rocket_refuel',
          label:    'Refuel Rocket',
          name:     'rocket[refuel]',
          required: true,
          value:    'true'
        )
      end
      let(:snapshot) do
        <<~HTML
          <label class="checkbox">
            <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

            <input id="rocket_refuel" name="rocket[refuel]" type="checkbox" checked="checked" required="required" value="true">

            <span class="ml-1">
              Refuel Rocket
            </span>
          </label>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
