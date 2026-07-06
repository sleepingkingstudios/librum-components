# frozen_string_literal: true

require 'librum/components/bulma/layouts/page/alerts'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Alerts,
  framework: :bulma,
  type:      :component \
do
  let(:alerts) do
    [
      {
        message: 'Reactor temperature critical',
        type:    'warning'
      },
      {
        dismissable: false,
        icon:        'radiation',
        message:     'Meltdown imminent',
        type:        'danger'
      }
    ]
  end
  let(:component_options) { { alerts: } }

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :alerts,
    value: -> { alerts }

  describe '.new' do
    context 'when initialized with alerts: nil' do
      let(:alerts) { nil }
      let(:error_message) do
        tools.assertions.error_message_for(:presence, as: 'alerts')
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when initialized with alerts: an Object' do
      let(:alerts) { Object.new.freeze }
      let(:error_message) do
        tools.assertions.error_message_for(
          :instance_of,
          as:       'alerts',
          expected: Array
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when initialized with alerts: an empty Array' do
      let(:alerts) { [] }
      let(:error_message) do
        tools.assertions.error_message_for(:presence, as: 'alerts')
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when initialized with alerts: an Array containing nil' do
      let(:alerts) { super().insert(1, nil) }
      let(:error_message) do
        tools.assertions.error_message_for(:presence, as: 'alerts[1]')
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when initialized with alerts: an Array containing an Object' do
      let(:alerts) { super().insert(1, Object.new.freeze) }
      let(:error_message) do
        tools.assertions.error_message_for(
          :instance_of,
          as:       'alerts[1]',
          expected: Hash
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when initialized with alerts: an Array containing an empty Hash' do
      let(:alerts) { super().insert(1, {}) } # rubocop:disable Rails/SkipsModelValidations
      let(:error_message) do
        'alerts[1] missing required keys (:message, :type)'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <div class="block">
          <div class="alert has-text-warning is-warning mb-1" x-on:close="open = false" x-data="{ open: true }" x-show="open">
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-#{theme.warning_icon}"></i>
            </span>

            Reactor temperature critical

            <button class="is-pulled-right" x-on:click="$dispatch('close')">
              <span class="icon">
                <i class="fa-solid fa-circle-xmark"></i>
              </span>
            </button>
          </div>

          <div class="alert has-text-danger is-danger mb-1">
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-radiation"></i>
            </span>

            Meltdown imminent
          </div>
        </div>
      HTML
    end

    include_deferred 'with configuration',
      default_icon_family: 'font-awesome',
      icon_families:       %i[font-awesome]

    include_deferred 'with theme'

    it { expect(rendered).to match_snapshot }
  end
end
