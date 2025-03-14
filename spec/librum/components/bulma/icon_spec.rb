# frozen_string_literal: true

require 'librum/components/bulma/icon'

require 'support/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Icon, type: :component do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:icon) { { family: 'fa-solid', icon: 'rainbow' } }
  let(:component_options) do
    { icon: }
  end

  describe '::ICON_SIZES' do
    include_examples 'should define frozen constant',
      :ICON_SIZES,
      Set.new(%w[small medium large])
  end

  include_deferred 'with configuration',
    colors:              %i[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :color,
    value: 'indigo'

  include_deferred 'should define component option', :icon

  include_deferred 'should define component option',
    :size,
    value: 'small'

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid color',
      :color

    include_deferred 'should validate the presence of option',
      :icon,
      string: true

    include_deferred 'should validate that option is a valid icon',
      :icon,
      required: true

    describe 'with size: an invalid value' do
      let(:size)              { 'tiny' }
      let(:component_options) { super().merge(size:) }
      let(:error_message)     { 'size is not a valid size' }

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Options::InvalidOptionsError,
            error_message
      end
    end
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <span class="icon">
          <i class="fa-solid fa-rainbow"></i>
        </span>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with color: value' do
      let(:component_options) do
        super().merge(color: 'indigo')
      end
      let(:snapshot) do
        <<~HTML
          <span class="icon has-text-indigo">
            <i class="fa-solid fa-rainbow"></i>
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with icon: an icon name' do
      let(:icon) { super()[:icon] }

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with icon: a component' do
      let(:icon) do
        Librum::Components::Icons::FontAwesome.new(**super())
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with icon: additional options for the icon' do
      let(:icon) { super().merge(size: 'xl', class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <span class="icon">
            <i class="fa-solid fa-rainbow fa-xl custom-class"></i>
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with size: value' do
      let(:component_options) do
        super().merge(size: 'medium')
      end
      let(:snapshot) do
        <<~HTML
          <span class="icon is-medium">
            <i class="fa-solid fa-rainbow"></i>
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    context 'with configuration: { bulma_prefix: value }' do
      let(:component_options) do
        super().merge(color: 'indigo', size: 'medium')
      end
      let(:snapshot) do
        <<~HTML
          <span class="bulma-icon bulma-has-text-indigo bulma-is-medium">
            <i class="fa-solid fa-rainbow"></i>
          </span>
        HTML
      end

      include_deferred 'with configuration',
        bulma_prefix:        'bulma-',
        colors:              %i[red orange yellow green blue indigo violet],
        default_icon_family: 'fa-solid',
        icon_families:       %i[fa-solid]

      it { expect(rendered.to_s).to match_snapshot }
    end
  end
end
