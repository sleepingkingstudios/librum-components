# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Level,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :left_items,
    default: [],
    value:   ['Greetings, programs!']

  include_deferred 'should define component option',
    :right_items,
    default: [],
    value:   ['Greetings, starfighter!']

  describe '.new' do
    describe 'with left_items: an Object' do
      let(:left_items)        { Object.new.freeze }
      let(:component_options) { super().merge(left_items:) }
      let(:error_message) do
        failure_message =
          SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:       'left_items',
            expected: Array
          )

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with left_items: an Array with invalid items' do
      let(:left_items) do
        [
          { ok: false },
          'Greetings, programs!',
          Object.new.freeze
        ]
      end
      let(:component_options) { super().merge(left_items:) }
      let(:error_message) do
        failure_message =
          'left_items 0 is not a component or HTML string, left_items 2 is ' \
          'not a component or HTML string'

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with right_items: an Object' do
      let(:right_items)       { Object.new.freeze }
      let(:component_options) { super().merge(right_items:) }
      let(:error_message) do
        failure_message =
          SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:       'right_items',
            expected: Array
          )

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with right_items: an Array with invalid items' do
      let(:right_items) do
        [
          { ok: false },
          'Greetings, programs!',
          Object.new.freeze
        ]
      end
      let(:component_options) { super().merge(right_items:) }
      let(:error_message) do
        failure_message =
          'right_items 0 is not a component or HTML string, right_items 2 is ' \
          'not a component or HTML string'

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#call' do
    describe 'with class_name: value and items' do
      let(:class_name)        { 'custom-class' }
      let(:left_items)        { ['Greetings, starfighter!'] }
      let(:component_options) { super().merge(class_name:, left_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level custom-class">
            <div class="level-left">
              <div class="level-item">
                Greetings, starfighter!
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with left_items: a String' do
      let(:left_items)        { ['Greetings, programs!'] }
      let(:component_options) { super().merge(left_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                Greetings, programs!
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with left_items: a component' do
      let(:left_items) do
        [
          Librum::Components::Literal.new(
            '<span>You have been recruited by the Star League...</span>'
          )
        ]
      end
      let(:component_options) { super().merge(left_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                <span>
                  You have been recruited by the Star League...
                </span>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with left_items: multiple items' do
      let(:left_items) do
        [
          'Greetings, starfighter!',
          Librum::Components::Literal.new(
            '<span>You have been recruited by the Star League...</span>'
          )
        ]
      end
      let(:component_options) { super().merge(left_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-left">
              <div class="level-item">
                Greetings, starfighter!
              </div>

              <div class="level-item">
                <span>
                  You have been recruited by the Star League...
                </span>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with right_items: a String' do
      let(:right_items)       { ['Confirm?'] }
      let(:component_options) { super().merge(right_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-right">
              <div class="level-item">
                Confirm?
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with right_items: a component' do
      let(:right_items) do
        [
          Librum::Components::Literal.new(
            '<span class="icon icon-bomb"></span>'
          )
        ]
      end
      let(:component_options) { super().merge(right_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-right">
              <div class="level-item">
                <span class="icon icon-bomb"></span>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with right_items: multiple items' do
      let(:right_items) do
        [
          'Confirm?',
          Librum::Components::Literal.new(
            '<span class="icon icon-bomb"></span>'
          )
        ]
      end
      let(:component_options) { super().merge(right_items:) }
      let(:snapshot) do
        <<~HTML
          <div class="level">
            <div class="level-right">
              <div class="level-item">
                Confirm?
              </div>

              <div class="level-item">
                <span class="icon icon-bomb"></span>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:class_name) { 'custom-class' }
      let(:left_items) do
        [
          'Greetings, starfighter!',
          Librum::Components::Literal.new(
            '<span>You have been recruited by the Star League...</span>'
          )
        ]
      end
      let(:right_items) do
        [
          'Confirm?',
          Librum::Components::Literal.new(
            '<span class="icon icon-bomb"></span>'
          )
        ]
      end
      let(:component_options) do
        super().merge(class_name:, left_items:, right_items:)
      end
      let(:snapshot) do
        <<~HTML
          <div class="level custom-class">
            <div class="level-left">
              <div class="level-item">
                Greetings, starfighter!
              </div>

              <div class="level-item">
                <span>
                  You have been recruited by the Star League...
                </span>
              </div>
            </div>

            <div class="level-right">
              <div class="level-item">
                Confirm?
              </div>

              <div class="level-item">
                <span class="icon icon-bomb"></span>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end
  end

  describe '#render?' do
    it { expect(component.render?).to be false }

    describe 'with left_items: value' do
      let(:left_items)        { %w[Greetings Programs] }
      let(:component_options) { super().merge(left_items:) }

      it { expect(component.render?).to be true }
    end

    describe 'with right_items: value' do
      let(:right_items)       { %w[Greetings Programs] }
      let(:component_options) { super().merge(right_items:) }

      it { expect(component.render?).to be true }
    end
  end
end
