# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::SelectOptionGroup,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) do
    { label:, values: }
  end
  let(:label)  { 'Space Programs' }
  let(:values) { [] }

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '.validate_option_group' do
    let(:as) { 'option group' }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:validate_option_group)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      let(:value) { nil }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          as:,
          expected: Hash
        )
      end

      it 'should return the error message' do
        expect(described_class.validate_option_group(value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_options' }

        it 'should return the error message' do
          expect(described_class.validate_option_group(value, as:))
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
          expected: Hash
        )
      end

      it 'should return the error message' do
        expect(described_class.validate_option_group(value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_options' }

        it 'should return the error message' do
          expect(described_class.validate_option_group(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an empty Hash' do
      let(:value) { {} }
      let(:error_message) do
        "#{as} is missing required properties :label, :items"
      end

      it 'should return the error message' do
        expect(described_class.validate_option_group(value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option_group(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a Hash with missing keys' do
      let(:value) { { label: 'Select Space Program' } }
      let(:error_message) do
        "#{as} is missing required property :items"
      end

      it 'should return the error message' do
        expect(described_class.validate_option_group(value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option_group(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a Hash with invalid keys' do
      let(:value) do
        {
          label:   'Morningstar Technologies',
          items:   [],
          invalid: 'value',
          other:   'other'
        }
      end
      let(:error_message) do
        "#{as} has unknown properties :invalid, :other"
      end

      it 'should return the error message' do
        expect(described_class.validate_option_group(value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option_group(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a Hash with empty items' do
      let(:value) do
        {
          label: 'Select Space Program',
          items: []
        }
      end

      it { expect(described_class.validate_option_group(value)).to be nil }
    end

    describe 'with a Hash with invalid items' do
      let(:value) do
        {
          label: 'Select Space Program',
          items: [
            { label: 'Avalon Heavy Industries', value: 'ahi' },
            nil,
            { label: 'Morningstar Technologies', value: 'mst', selected: true },
            {},
            { label: 'Greased Lightning Agency', value: 'gla', disabled: true },
            { label: 'Moosecosmos', secret: 'squirrel' }
          ]
        }
      end
      let(:error_message) do
        "#{as} item 1 is not an instance of Hash, #{as} item 3 is missing " \
          "required property :label, #{as} item 5 has unknown property :secret"
      end

      it 'should return the error message' do
        expect(described_class.validate_option_group(value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_options' }

        it 'should return the error message' do
          expect(described_class.validate_option_group(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a Hash with valid items' do
      let(:value) do
        {
          label: 'Select Space Program',
          items: [
            { label: 'Avalon Heavy Industries',  value: 'ahi' },
            { label: 'Morningstar Technologies', value: 'mst' }
          ]
        }
      end

      it { expect(described_class.validate_option_group(value)).to be nil }
    end
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

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :label,
    value: 'Choose Option'

  include_deferred 'should define component option',
    :selected_value,
    value: 'ahi'

  include_deferred 'should define component option',
    :values,
    value: [{ label: 'Avalon Heavy Industries' }]

  describe '.new' do
    include_deferred 'should validate the presence of option', :label

    include_deferred 'should validate the type of option',
      :label,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :selected_value,
      allow_nil: true,
      expected:  String

    describe 'with values: an Object' do
      let(:component_options) do
        super().merge(values: Object.new.freeze)
      end
      let(:as) { 'values' }
      let(:error_message) do
        failure_message = tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          as:,
          expected: Array
        )

        "invalid options for #{described_class.name} - #{failure_message}"
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
        failure_message =
          "#{as} item 1 is not an instance of Hash, #{as} item 3 is missing " \
          "required property :label, #{as} item 5 has unknown property :secret"

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#call' do
    describe 'with values: a non-empty Array' do
      let(:values) do
        [
          { label: 'Avalon Heavy Industries',  value: 'ahi' },
          { label: 'Morningstar Technologies', value: 'mst' }
        ]
      end
      let(:snapshot) do
        <<~HTML
          <optgroup label="Space Programs">
            <option value="ahi">
              Avalon Heavy Industries
            </option>

            <option value="mst">
              Morningstar Technologies
            </option>
          </optgroup>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with selected_value: a non-matching value' do
        let(:component_options) { super().merge(selected_value: 'glm') }

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with selected_value: a matching value' do
        let(:component_options) { super().merge(selected_value: 'mst') }
        let(:snapshot) do
          <<~HTML
            <optgroup label="Space Programs">
              <option value="ahi">
                Avalon Heavy Industries
              </option>

              <option value="mst" selected="selected">
                Morningstar Technologies
              </option>
            </optgroup>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#render?' do
    it { expect(component.render?).to be false }

    describe 'with values: an empty Array' do
      let(:values) { [] }

      it { expect(component.render?).to be false }
    end

    describe 'with values: a non-empty Array' do
      let(:values) { [{ label: 'Avalon Heavy Industries' }] }

      it { expect(component.render?).to be true }
    end
  end
end
