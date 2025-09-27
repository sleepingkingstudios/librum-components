# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Options::DataAttributes do
  include Librum::Components::RSpec::Deferred::OptionsExamples

  subject(:component) { described_class.new(**component_options) }

  let(:described_class)   { Spec::ExampleComponent }
  let(:component_options) { {} }

  example_class 'Spec::ExampleComponent' do |klass|
    klass.include Librum::Components::Options
    klass.include Librum::Components::Options::DataAttributes # rubocop:disable RSpec/DescribedClass
  end

  include_deferred 'should define component option', :data, value: {}

  describe '.new' do
    include_deferred 'should validate the data option'
  end

  describe '.flatten_hash' do
    let(:described_class) { Librum::Components::Options::DataAttributes } # rubocop:disable RSpec/DescribedClass
    let(:flattened)       { described_class.flatten_hash(data) }

    it { expect(described_class).to respond_to(:flatten_hash).with(1).argument }

    describe 'with nil' do
      let(:data) { nil }

      it { expect(flattened).to be == {} }
    end

    context 'with data: an empty Hash' do
      let(:data) { {} }

      it { expect(flattened).to be == {} }
    end

    context 'with data: a Hash with String keys' do
      let(:data) do
        {
          'controller'        => 'countdown',
          'data_action'       => 'submit->countdown#start',
          'countdown_message' => 'Self-Destruct Sequence Initiated'
        }
      end
      let(:expected) do
        {
          'data-controller'        => 'countdown',
          'data-action'            => 'submit->countdown#start',
          'data-countdown-message' => 'Self-Destruct Sequence Initiated'
        }
      end

      it { expect(flattened).to be == expected }

      context 'with a nested Hash' do
        let(:data) do
          {
            'controller'  => 'countdown',
            'data_action' => 'submit->countdown#start',
            'countdown'   => {
              'message'       => 'Self-Destruct Sequence Initiated',
              'timer_seconds' => 10,
              'cancellation'  => {
                'action'   => nil,
                'data'     => { 'status' => { 'ok' => false } },
                'fallback' => '',
                'message'  => 'Out Of Order'
              }
            }
          }
        end
        let(:expected) do
          super().merge(
            'data-countdown-timer-seconds'               => '10',
            'data-countdown-cancellation-data-status-ok' => 'false',
            'data-countdown-cancellation-message'        => 'Out Of Order'
          )
        end

        it { expect(flattened).to deep_match expected }
      end
    end

    context 'with data: a Hash with Symbol keys' do
      let(:data) do
        {
          controller:        'countdown',
          data_action:       'submit->countdown#start',
          countdown_message: 'Self-Destruct Sequence Initiated'
        }
      end
      let(:expected) do
        {
          'data-controller'        => 'countdown',
          'data-action'            => 'submit->countdown#start',
          'data-countdown-message' => 'Self-Destruct Sequence Initiated'
        }
      end

      it { expect(flattened).to be == expected }

      context 'with a nested Hash' do
        let(:data) do
          {
            controller:  'countdown',
            data_action: 'submit->countdown#start',
            countdown:   {
              message:       'Self-Destruct Sequence Initiated',
              timer_seconds: 10,
              cancellation:  {
                action:   nil,
                data:     { status: { ok: false } },
                fallback: '',
                message:  'Out Of Order'
              }
            }
          }
        end
        let(:expected) do
          super().merge(
            'data-countdown-timer-seconds'               => '10',
            'data-countdown-cancellation-data-status-ok' => 'false',
            'data-countdown-cancellation-message'        => 'Out Of Order'
          )
        end

        it { expect(flattened).to deep_match expected }
      end
    end
  end

  describe '#data' do
    context 'when initialized with data: a Hash with String keys' do
      let(:component_options) { super().merge(data:) }
      let(:data) do
        {
          'controller'        => 'countdown',
          'data_action'       => 'submit->countdown#start',
          'countdown_message' => 'Self-Destruct Sequence Initiated'
        }
      end
      let(:expected) do
        {
          'action'            => 'submit->countdown#start',
          'controller'        => 'countdown',
          'countdown-message' => 'Self-Destruct Sequence Initiated'
        }
      end

      it { expect(component.data).to be == expected }

      context 'with a nested Hash' do
        let(:data) do
          {
            'controller'  => 'countdown',
            'data_action' => 'submit->countdown#start',
            'countdown'   => {
              'message'       => 'Self-Destruct Sequence Initiated',
              'timer_seconds' => 10,
              'cancellation'  => {
                'action'   => nil,
                'data'     => { 'status' => { 'ok' => false } },
                'fallback' => '',
                'message'  => 'Out Of Order'
              }
            }
          }
        end
        let(:expected) do
          super().merge(
            'countdown-cancellation-data-status-ok' => 'false',
            'countdown-cancellation-message'        => 'Out Of Order',
            'countdown-timer-seconds'               => '10'
          )
        end

        it { expect(component.data).to deep_match expected }
      end
    end

    context 'when initialized with data: a Hash with Symbol keys' do
      let(:component_options) { super().merge(data:) }
      let(:data) do
        {
          controller:        'countdown',
          data_action:       'submit->countdown#start',
          countdown_message: 'Self-Destruct Sequence Initiated'
        }
      end
      let(:expected) do
        {
          'action'            => 'submit->countdown#start',
          'controller'        => 'countdown',
          'countdown-message' => 'Self-Destruct Sequence Initiated'
        }
      end

      it { expect(component.data).to be == expected }

      context 'with a nested Hash' do
        let(:data) do
          {
            controller:  'countdown',
            data_action: 'submit->countdown#start',
            countdown:   {
              message:       'Self-Destruct Sequence Initiated',
              timer_seconds: 10,
              cancellation:  {
                action:   nil,
                data:     { status: { ok: false } },
                fallback: '',
                message:  'Out Of Order'
              }
            }
          }
        end
        let(:expected) do
          super().merge(
            'countdown-cancellation-data-status-ok' => 'false',
            'countdown-cancellation-message'        => 'Out Of Order',
            'countdown-timer-seconds'               => '10'
          )
        end

        it { expect(component.data).to deep_match expected }
      end
    end
  end

  describe '#render_data' do
    let(:rendered) { component.render_data }

    it { expect(component).to respond_to(:render_data).with(0).arguments }

    it { expect(rendered).to be nil }

    context 'with data: an empty Hash' do
      let(:component_options) { super().merge(data: {}) }

      it { expect(rendered).to be nil }
    end

    context 'with data: a Hash with String keys' do
      let(:component_options) { super().merge(data:) }
      let(:data) do
        {
          'controller'        => 'countdown',
          'data_action'       => 'submit->countdown#start',
          'countdown_message' => '<p>Self-Destruct Sequence Initiated</p>'
        }
      end
      let(:expected) do
        ' data-controller="countdown" data-action="submit->countdown#start" ' \
          'data-countdown-message="Self-Destruct Sequence Initiated"'
      end

      it { expect(rendered).to be == expected }

      context 'with a nested Hash' do
        let(:data) do
          {
            'controller'  => 'countdown',
            'data_action' => 'submit->countdown#start',
            'countdown'   => {
              'message'       => 'Self-Destruct Sequence Initiated',
              'timer_seconds' => 10,
              'cancellation'  => {
                'action'   => nil,
                'data'     => { 'status' => { 'ok' => false } },
                'fallback' => '',
                'message'  => 'Out Of Order'
              }
            }
          }
        end
        let(:expected) do
          %(#{super()} data-countdown-timer-seconds="10" ) +
            'data-countdown-cancellation-data-status-ok="false" ' \
            'data-countdown-cancellation-message="Out Of Order"'
        end

        it { expect(rendered).to be == expected }
      end
    end

    context 'with data: a Hash with Symbol keys' do
      let(:component_options) { super().merge(data:) }
      let(:data) do
        {
          controller:        'countdown',
          data_action:       'submit->countdown#start',
          countdown_message: 'Self-Destruct Sequence Initiated'
        }
      end
      let(:expected) do
        ' data-controller="countdown" data-action="submit->countdown#start" ' \
          'data-countdown-message="Self-Destruct Sequence Initiated"'
      end

      it { expect(rendered).to be == expected }

      context 'with a nested Hash' do
        let(:data) do
          {
            controller:  'countdown',
            data_action: 'submit->countdown#start',
            countdown:   {
              message:       'Self-Destruct Sequence Initiated',
              timer_seconds: 10,
              cancellation:  {
                action:   nil,
                data:     { status: { ok: false } },
                fallback: '',
                message:  'Out Of Order'
              }
            }
          }
        end
        let(:expected) do
          %(#{super()} data-countdown-timer-seconds="10" ) +
            'data-countdown-cancellation-data-status-ok="false" ' \
            'data-countdown-cancellation-message="Out Of Order"'
        end

        it { expect(rendered).to be == expected }
      end
    end
  end
end
