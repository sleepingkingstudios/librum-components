# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::TextArea,
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

  include_deferred 'should define component option',
    :fixed_size,
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
    :rows,
    value: 5

  include_deferred 'should define component option',
    :size,
    value: 'mid'

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

    include_deferred 'should validate the type of option',
      :rows,
      allow_nil: true,
      expected:  Integer

    include_deferred 'should validate that option is a valid size', :size
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <textarea class="textarea"></textarea>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea custom-class"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'red') }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea is-red"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: true' do
      let(:component_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" disabled="disabled"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:component_options) { super().merge(id: 'rocket_description') }
      let(:snapshot) do
        <<~HTML
          <textarea id="rocket_description" class="textarea"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with name: value' do
      let(:component_options) { super().merge(name: 'rocket[description]') }
      let(:snapshot) do
        <<~HTML
          <textarea name="rocket[description]" class="textarea"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with placeholder: value' do
      let(:component_options) do
        super().merge(placeholder: 'Rocket Description')
      end
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" placeholder="Rocket Description"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with read_only: true' do
      let(:component_options) { super().merge(read_only: true) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" readonly="readonly"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with required: true' do
      let(:component_options) { super().merge(required: true) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" required="required"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with rows: value' do
      let(:component_options) { super().merge(rows: 5) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea" rows="5"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with size: value' do
      let(:component_options) { super().merge(size: 'max') }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea is-max"></textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:description) do
        'A second-generation orbital rocket designed for lunar operations.'
      end
      let(:component_options) { super().merge(value: description) }
      let(:snapshot) do
        <<~HTML
          <textarea class="textarea">
            A second-generation orbital rocket designed for lunar operations.
          </textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:description) do
        'A second-generation orbital rocket designed for lunar operations.'
      end
      let(:component_options) do
        super().merge(
          class_name:  'custom-class',
          color:       'red',
          id:          'rocket_description',
          name:        'rocket[description]',
          placeholder: 'Rocket Description',
          size:        'max',
          value:       description
        )
      end
      let(:snapshot) do
        <<~HTML
          <textarea id="rocket_description" name="rocket[description]" class="textarea is-red is-max custom-class" placeholder="Rocket Description">
            A second-generation orbital rocket designed for lunar operations.
          </textarea>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
