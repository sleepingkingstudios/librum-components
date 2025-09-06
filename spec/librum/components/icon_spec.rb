# frozen_string_literal: true

require 'librum/components/icon'
require 'librum/components/icons/font_awesome'
require 'librum/components/rspec/deferred/component_examples'

RSpec.describe Librum::Components::Icon, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:icon) { 'rainbow' }
  let(:component_options) do
    { icon: }
  end

  include_deferred 'with configuration',
    default_icon_family: 'iconicons',
    icon_families:       %i[bootstrap material-design iconicons]

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
          .to raise_error Librum::Components::Errors::InvalidOptionsError,
            include(error_message)
      end
    end

    context 'when the configuration does not define a default icon family' do
      include_deferred 'with configuration',
        default_icon_family: nil,
        icon_families:       %i[bootstrap material-design iconicons]

      include_deferred 'should validate the type of option',
        :family,
        expected: String
    end
  end

  describe '.build' do
    describe 'with an icon component' do
      let(:icon_component) do
        Librum::Components::Icons::FontAwesome.new(
          family: 'fa-solid',
          icon:   'rainbow'
        )
      end

      it { expect(described_class.build(icon_component)).to be icon_component }
    end

    describe 'with an icon name' do
      context 'when the default icon family is FontAwesome' do
        include_deferred 'with configuration',
          default_icon_family: 'fa-solid',
          icon_families:       %i[fa-brands fa-solid]

        it { expect(described_class.build(icon)).to be_a described_class }

        it { expect(described_class.build(icon).icon).to be == icon }

        describe 'with options' do
          let(:options) { { size: 'xl' } }

          it 'should pass the options to the component' do
            expect(described_class.build(icon, **options).options[:size])
              .to be == 'xl'
          end
        end
      end
    end
  end

  describe '#call' do
    let(:rendered) { render_component(component) }

    describe 'with family: FontAwesome' do
      let(:component_options) do
        super().merge(family: 'fa-solid')
      end
      let(:expected) do
        icon = Librum::Components::Icons::FontAwesome.new(**component_options)

        render_component(icon)
      end

      include_deferred 'with configuration',
        default_icon_family: 'iconicons',
        icon_families:       %i[fa-brands fa-solid]

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
