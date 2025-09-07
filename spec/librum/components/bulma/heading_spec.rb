# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Heading, type: :component do
  include Librum::Components::RSpec::Deferred::BulmaExamples
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:text) do
    'Greetings, Starfighter'
  end
  let(:component_options)   { { text: } }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'should be a view component'

  include_deferred 'should define typography options'

  include_deferred 'should define component option',
    :actions,
    value: [{ text: 'Launch' }]

  include_deferred 'should define component option',
    :level,
    value: 3

  include_deferred 'should define component option', :text

  describe '.new' do
    include_deferred 'should validate the presence of option', :text

    include_deferred 'should validate that option is a valid array',
      :actions,
      invalid_item: Object.new.freeze,
      item_message: 'is not a component or options Hash',
      valid_items:  [{ icon: 'left-arrow' }, { icon: 'right-arrow' }]

    describe 'with level: an Object' do
      let(:component_options) do
        super().merge(level: Object.new.freeze)
      end
      let(:error_message) do
        'level is not an instance of Integer'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }.to raise_error(
          Librum::Components::Errors::InvalidOptionsError,
          error_message
        )
      end
    end

    describe 'with level: an Integer less than 1' do
      let(:component_options) do
        super().merge(level: 0)
      end
      let(:error_message) do
        'level is outside the range of 1 to 6'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }.to raise_error(
          Librum::Components::Errors::InvalidOptionsError,
          error_message
        )
      end
    end

    describe 'with level: an Integer greater than 6' do
      let(:component_options) do
        super().merge(level: 7)
      end
      let(:error_message) do
        'level is outside the range of 1 to 6'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }.to raise_error(
          Librum::Components::Errors::InvalidOptionsError,
          error_message
        )
      end
    end
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <span class="title is-block mb-5">Greetings, Starfighter</span>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with actions: an Array of components' do
      let(:actions) do
        [
          Librum::Components::Literal.new('<a>Link</a>'),
          Librum::Components::Literal.new('<a class="button">Button</a>')
        ]
      end
      let(:component_options) { super().merge(actions:) }
      let(:snapshot) do
        <<~HTML
          <div class="level mb-5">
            <div class="level-left">
              <span class="title">Greetings, Starfighter</span>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a>Link</a>
              </div>

              <div class="level-item">
                <a class="button">Button</a>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with actions: an Array of options' do
      let(:actions) do
        [
          { text: 'Link' },
          { text: 'Button', button: true }
        ]
      end
      let(:component_options) { super().merge(actions:) }
      let(:snapshot) do
        <<~HTML
          <div class="level mb-5">
            <div class="level-left">
              <span class="title">Greetings, Starfighter</span>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a>
                  Link
                </a>
              </div>

              <div class="level-item">
                <a class="button">
                  Button
                </a>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-heading') }
      let(:snapshot) do
        <<~HTML
          <span class="title is-block mb-5 custom-heading">Greetings, Starfighter</span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with level: value' do
      let(:component_options) { super().merge(level: 2) }
      let(:snapshot) do
        <<~HTML
          <h2>Greetings, Starfighter</h2>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with level: value and class_name: value' do
      let(:component_options) do
        super().merge(class_name: 'custom-heading', level: 2)
      end
      let(:snapshot) do
        <<~HTML
          <h2 class="custom-heading">Greetings, Starfighter</h2>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with typography options' do
      let(:component_options) { super().merge(size: 3) }
      let(:snapshot) do
        <<~HTML
          <span class="title is-block mb-5 is-size-3">Greetings, Starfighter</span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:actions) do
        [
          { text: 'Link' },
          { text: 'Button', button: true }
        ]
      end
      let(:component_options) do
        super().merge(actions:, class_name: 'custom-heading', level: 2, size: 3)
      end
      let(:snapshot) do
        <<~HTML
          <div class="level mb-5">
            <div class="level-left">
              <h2 class="mb-0 is-size-3 custom-heading">Greetings, Starfighter</h2>
            </div>

            <div class="level-right">
              <div class="level-item">
                <a>
                  Link
                </a>
              </div>

              <div class="level-item">
                <a class="button">
                  Button
                </a>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
