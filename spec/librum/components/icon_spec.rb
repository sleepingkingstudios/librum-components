# frozen_string_literal: true

require 'librum/components/icon'

require 'support/deferred/component_examples'

RSpec.describe Librum::Components::Icon, type: :component do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:icon) { 'rainbow' }
  let(:configuration) do
    Librum::Components::Configuration.new(
      default_icon_family: 'iconicons',
      icon_families:       %i[bootstrap material-design iconicons]
    )
  end
  let(:component_options) do
    { configuration:, icon: }
  end

  include_deferred 'should be a view component',
    allow_extra_options: true

  describe '.new' do
    include_deferred 'should validate the presence of option',
      :icon,
      string: true

    context 'when initialized with family: a value not in the configuration' do
      let(:family) { 'decepticons' }
      let(:component_options) do
        super().merge(family:)
      end
      let(:error_message) do
        'family is not a configured icon family'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Options::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when the configuration does not define a default icon family' do
      let(:configuration) do
        Librum::Components::Configuration.new(
          default_icon_family: nil,
          icon_families:       %i[bootstrap material-design iconicons]
        )
      end

      include_deferred 'should validate the type of option',
        :family,
        expected: String
    end
  end

  describe '#call' do
    let(:rendered) { render_component(component) }

    describe 'with family: FontAwesome' do
      let(:configuration) do
        Librum::Components::Configuration.new(
          default_icon_family: 'iconicons',
          icon_families:       %i[fa-brands fa-solid]
        )
      end
      let(:component_options) do
        super().merge(family: 'fa-solid')
      end
      let(:expected) do
        icon = Librum::Components::Icons::FontAwesome.new(**component_options)

        render_component(icon)
      end

      it { expect(rendered).to be == expected }

      describe 'with additional options' do
        let(:component_options) do
          super().merge(class_name: 'custom-class', size: 'xl')
        end

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with an unknown icon family' do
      let(:snapshot) do
        <<~HTML
          <i class="fa-solid fa-bug" style="color: red;" data-family="iconicons" data-icon="rainbow"></i>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end
  end

  describe '#family' do
    include_examples 'should define reader',
      :family,
      -> { configuration.default_icon_family }

    context 'when initialized with family: value' do
      let(:family) { 'material-design' }
      let(:component_options) do
        super().merge(family:)
      end

      it { expect(component.family).to be == family }
    end
  end
end
