# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Icon,
  framework: :bulma,
  type:      :component \
do
  let(:icon) { { family: 'fa-solid', icon: 'rainbow' } }
  let(:component_options) do
    { icon: }
  end

  include_deferred 'with configuration',
    colors:              %i[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid],
    sizes:               %w[min mid max]

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :color,
    value: 'indigo'

  include_deferred 'should define component option', :icon

  include_deferred 'should define component option',
    :size,
    value: 'mid'

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid color',
      :color

    include_deferred 'should validate the presence of option',
      :icon,
      string: true

    include_deferred 'should validate that option is a valid icon', :icon

    include_deferred 'should validate that option is a valid size', :size
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
        super().merge(size: 'max')
      end
      let(:snapshot) do
        <<~HTML
          <span class="icon is-max">
            <i class="fa-solid fa-rainbow"></i>
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    context 'with configuration: { bulma_prefix: value }' do
      let(:component_options) do
        super().merge(color: 'indigo', size: 'max')
      end
      let(:snapshot) do
        <<~HTML
          <span class="bulma-icon bulma-has-text-indigo bulma-is-max">
            <i class="fa-solid fa-rainbow"></i>
          </span>
        HTML
      end

      include_deferred 'with configuration', bulma_prefix: 'bulma-'

      it { expect(rendered.to_s).to match_snapshot }
    end
  end
end
