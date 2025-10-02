# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::SelectOption,
  type: :component \
do
  let(:component_options) { { label: } }
  let(:label)             { 'Morningstar Technologies' }

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '.validate_option' do
    let(:as) { 'option' }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:validate_option)
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
        expect(described_class.validate_option(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option(value, as:))
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
        expect(described_class.validate_option(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an empty Hash' do
      let(:value) { {} }
      let(:error_message) do
        "#{as} is missing required property :label"
      end

      it 'should return the error message' do
        expect(described_class.validate_option(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a Hash with invalid keys' do
      let(:value) do
        {
          label:   'Morningstar Technologies',
          invalid: 'value',
          other:   'other'
        }
      end
      let(:error_message) do
        "#{as} has unknown properties :invalid, :other"
      end

      it 'should return the error message' do
        expect(described_class.validate_option(value)).to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'select_option' }

        it 'should return the error message' do
          expect(described_class.validate_option(value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a valid Hash' do
      let(:value) do
        {
          label:    'Morningstar Technologies',
          value:    'mst',
          disabled: false,
          selected: true
        }
      end

      it { expect(described_class.validate_option(value)).to be nil }
    end
  end

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :disabled,
    boolean: true

  include_deferred 'should define component option',
    :label,
    value: 'Morningstar Technologies'

  include_deferred 'should define component option',
    :selected,
    boolean: true

  include_deferred 'should define component option',
    :value,
    value: 'mst'

  describe '.new' do
    include_deferred 'should validate that option is a valid name', :label

    include_deferred 'should validate the type of option',
      :value,
      allow_nil: true,
      expected:  String
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <option>
          Morningstar Technologies
        </option>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with disabled: true' do
      let(:component_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <option disabled="disabled">
            Morningstar Technologies
          </option>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with selected: true' do
      let(:component_options) { super().merge(selected: true) }
      let(:snapshot) do
        <<~HTML
          <option selected="selected">
            Morningstar Technologies
          </option>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with value: value' do
      let(:component_options) { super().merge(value: 'mst') }
      let(:snapshot) do
        <<~HTML
          <option value="mst">
            Morningstar Technologies
          </option>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) { super().merge(value: 'mst', selected: true) }
      let(:snapshot) do
        <<~HTML
          <option value="mst" selected="selected">
            Morningstar Technologies
          </option>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
