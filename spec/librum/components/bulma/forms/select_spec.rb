# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::Select,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { values: } }
  let(:values) do
    [
      { label: 'Avalon Heavy Industries',  value: 'ahi' },
      { label: 'Morningstar Technologies', value: 'mst' }
    ]
  end

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '.validate_options' do
    let(:as) { 'options' }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:validate_options)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      let(:value) { nil }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          as:,
          expected: Array
        )
      end

      it 'should return the error message' do
        expect(described_class.validate_options(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_options' }

        it 'should return the error message' do
          expect(described_class.validate_options(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an Object' do
      let(:value) { Object.new.freeze }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          as:,
          expected: Array
        )
      end

      it 'should return the error message' do
        expect(described_class.validate_options(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_options' }

        it 'should return the error message' do
          expect(described_class.validate_options(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an empty Array' do
      it { expect(described_class.validate_options([])).to be nil }
    end

    describe 'with a Array with valid options' do
      let(:value) do
        [
          { label: 'Avalon Heavy Industries',  value: 'ahi' },
          { label: 'Morningstar Technologies', value: 'mst', selected: true },
          { label: 'Greased Lightning Agency', value: 'gla', disabled: true }
        ]
      end

      it { expect(described_class.validate_options(value)).to be nil }
    end

    describe 'with a Array with invalid keys' do
      let(:value) do
        [
          { label: 'Avalon Heavy Industries', value: 'ahi' },
          nil,
          { label: 'Morningstar Technologies', value: 'mst', selected: true },
          {},
          { label: 'Greased Lightning Agency', value: 'gla', disabled: true },
          { label: 'Moosecosmos', secret: 'squirrel' }
        ]
      end
      let(:error_message) do
        "#{as} item 1 is not an instance of Hash, #{as} item 3 is missing " \
          "required property :label, #{as} item 5 has unknown property :secret"
      end

      it 'should return the error message' do
        expect(described_class.validate_options(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_options' }

        it 'should return the error message' do
          expect(described_class.validate_options(value, as:))
            .to be == error_message
        end
      end
    end
  end

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
    :full_width,
    boolean: true

  include_deferred 'should define component option',
    :id,
    value: 'game_space_program'

  include_deferred 'should define component option',
    :multiple,
    boolean: true

  include_deferred 'should define component option',
    :name,
    value: 'game[space_program]'

  include_deferred 'should define component option',
    :placeholder,
    value: 'Choose Space Program'

  include_deferred 'should define component option',
    :required,
    boolean: true

  include_deferred 'should define component option',
    :size,
    value: 'max'

  include_deferred 'should define component option', :value

  include_deferred 'should define component option',
    :values,
    value: [{ label: 'Avalon Heavy Industries' }]

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

    include_deferred 'should validate the type of option',
      :value,
      allow_nil: true,
      expected:  String

    describe 'with values: nil' do
      let(:component_options) do
        super().merge(values: nil)
      end
      let(:as) { 'values' }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as:
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with values: an Object' do
      let(:component_options) do
        super().merge(values: Object.new.freeze)
      end
      let(:as) { 'values' }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          as:,
          expected: Array
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with values: an empty Array' do
      let(:component_options) do
        super().merge(values: [])
      end
      let(:as) { 'values' }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as:
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with values: an Array with invalid items' do
      let(:values) do
        [
          { label: 'Avalon Heavy Industries', value: 'ahi' },
          nil,
          { label: 'Morningstar Technologies', value: 'mst', selected: true },
          {},
          { label: 'Greased Lightning Agency', value: 'gla', disabled: true },
          { label: 'Moosecosmos', secret: 'squirrel' }
        ]
      end
      let(:component_options) do
        super().merge(values:)
      end
      let(:as) { 'values' }
      let(:error_message) do
        "#{as} item 1 is not an instance of Hash, #{as} item 3 is missing " \
          "required property :label, #{as} item 5 has unknown property :secret"
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
        <div class="select">
          <select>
            <option value="ahi">
              Avalon Heavy Industries
            </option>

            <option value="mst">
              Morningstar Technologies
            </option>
          </select>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <div class="select custom-class">
            <select>
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'red') }
      let(:snapshot) do
        <<~HTML
          <div class="select is-red">
            <select>
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: true' do
      let(:component_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select disabled="disabled">
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with full_width: true' do
      let(:component_options) { super().merge(full_width: true) }
      let(:snapshot) do
        <<~HTML
          <div class="select is-block">
            <select>
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with id: value' do
      let(:component_options) { super().merge(id: 'game_space_program') }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select id="game_space_program">
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple: true' do
      let(:component_options) { super().merge(multiple: true) }
      let(:snapshot) do
        <<~HTML
          <div class="select is-multiple">
            <select multiple="multiple">
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with name: value' do
      let(:component_options) { super().merge(name: 'game[space_program]') }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select name="game[space_program]">
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with placeholder: value' do
      let(:component_options) do
        super().merge(placeholder: 'Choose Space Program')
      end
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select>
              <option value="" disabled="disabled">
                Choose Space Program
              </option>

              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with required: true' do
      let(:component_options) do
        super().merge(required: true)
      end
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select required="required">
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with size: value' do
      let(:component_options) { super().merge(size: 'max') }
      let(:snapshot) do
        <<~HTML
          <div class="select is-max">
            <select>
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: non-matching value' do
      let(:component_options) { super().merge(value: 'esa') }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select>
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: matching value' do
      let(:component_options) { super().merge(value: 'mst') }
      let(:snapshot) do
        <<~HTML
          <div class="select">
            <select>
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst" selected="selected">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          class_name:  'custom-class',
          color:       'red',
          full_width:  true,
          id:          'game_space_program',
          name:        'game[space_program]',
          placeholder: 'Choose Space Program',
          required:    true,
          value:       'mst'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="select is-red is-block custom-class">
            <select id="game_space_program" name="game[space_program]" required="required">
              <option value="" disabled="disabled">
                Choose Space Program
              </option>

              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst" selected="selected">
                Morningstar Technologies
              </option>
            </select>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
