# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::Input,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'with configuration',
    colors: %w[red orange yellow green blue indigo violet],
    sizes:  %w[min mid max]

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :class_name

  include_deferred 'should define component option',
    :color,
    value: 'red'

  include_deferred 'should define component option',
    :disabled,
    boolean: true

  include_deferred 'should define component option', :id

  include_deferred 'should define component option', :name

  include_deferred 'should define component option', :placeholder

  include_deferred 'should define component option',
    :read_only,
    boolean: true

  include_deferred 'should define component option',
    :required,
    boolean: true

  include_deferred 'should define component option',
    :size,
    value: 'mid'

  include_deferred 'should define component option',
    :static,
    boolean: true

  include_deferred 'should define component option',
    :type,
    default: 'text',
    value:   'email'

  include_deferred 'should define component option', :value

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid color', :color

    include_deferred 'should validate the type of option',
      :id,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :placeholder,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate that option is a valid size', :size

    include_deferred 'should validate that option is a valid name', :type
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <input class="input" type="text">
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <input class="input custom-class" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'red') }
      let(:snapshot) do
        <<~HTML
          <input class="input is-red" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled' do
      let(:component_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <input class="input" disabled="disabled" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:component_options) { super().merge(id: 'rocket_name') }
      let(:snapshot) do
        <<~HTML
          <input id="rocket_name" class="input" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with name: value' do
      let(:component_options) { super().merge(name: 'rocket[name]') }
      let(:snapshot) do
        <<~HTML
          <input name="rocket[name]" class="input" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with placeholder: value' do
      let(:component_options) { super().merge(placeholder: 'Rocket Name') }
      let(:snapshot) do
        <<~HTML
          <input class="input" placeholder="Rocket Name" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with read_only: true' do
      let(:component_options) { super().merge(read_only: true) }
      let(:snapshot) do
        <<~HTML
          <input class="input" readonly="readonly" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with required: true' do
      let(:component_options) { super().merge(required: true) }
      let(:snapshot) do
        <<~HTML
          <input class="input" required="required" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with size: value' do
      let(:component_options) { super().merge(size: 'mid') }
      let(:snapshot) do
        <<~HTML
          <input class="input is-mid" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with static: true' do
      let(:component_options) { super().merge(static: true) }
      let(:snapshot) do
        <<~HTML
          <input class="input is-static" readonly="readonly" type="text">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with type: value' do
      let(:component_options) { super().merge(type: 'email') }
      let(:snapshot) do
        <<~HTML
          <input class="input" type="email">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:component_options) { super().merge(value: 'Hellhound IV') }
      let(:snapshot) do
        <<~HTML
          <input class="input" type="text" value="Hellhound IV">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          class_name:  'custom-class',
          color:       'red',
          id:          'rocket_name',
          name:        'rocket[name]',
          placeholder: 'Rocket Name',
          size:        'max',
          value:       'Hellhound IV'
        )
      end
      let(:snapshot) do
        <<~HTML
          <input id="rocket_name" name="rocket[name]" class="input is-red is-max custom-class" placeholder="Rocket Name" type="text" value="Hellhound IV">
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
