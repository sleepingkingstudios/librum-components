# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Link,
  framework: :bulma,
  type:      :component \
do
  describe '::LINK_TARGETS' do
    include_examples 'should define frozen constant',
      :LINK_TARGETS,
      Set.new(%w[blank self])
  end

  include_deferred 'with configuration',
    colors:              %i[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component'

  include_deferred 'should define typography options'

  include_deferred 'should define component option', :button, boolean: true

  include_deferred 'should define component option', :class_name

  include_deferred 'should define component option',
    :color,
    value: 'indigo'

  include_deferred 'should define component option', :icon

  include_deferred 'should define component option',
    :target,
    value: 'blank'

  include_deferred 'should define component option', :text

  include_deferred 'should define component option', :url

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid color',
      :color

    include_deferred 'should validate that option is a valid icon', :icon

    include_deferred 'should validate the inclusion of option',
      :target,
      expected: described_class::LINK_TARGETS

    include_deferred 'should validate that option is a valid name', :url
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <a></a>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with button: true' do
      let(:component_options) { super().merge(button: true) }
      let(:snapshot) do
        <<~HTML
          <a class="button"></a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <a class="custom-class"></a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'indigo') }
      let(:snapshot) do
        <<~HTML
          <a class="has-text-indigo"></a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with icon: value' do
      let(:component_options) { super().merge(icon: 'rainbow') }
      let(:snapshot) do
        <<~HTML
          <a>
            <span class="icon">
              <i class="fa-solid fa-rainbow"></i>
            </span>
          </a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with icon: value and text: value' do
      let(:component_options) do
        super().merge(icon: 'rainbow', text: 'The More You Know')
      end
      let(:snapshot) do
        <<~HTML
          <a class="icon-text">
            <span class="icon">
              <i class="fa-solid fa-rainbow"></i>
            </span>

            The More You Know
          </a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with target: value' do
      let(:component_options) { super().merge(target: 'blank') }
      let(:snapshot) do
        <<~HTML
          <a target="_blank"></a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with text: value' do
      let(:component_options) { super().merge(text: 'Click Me') }
      let(:snapshot) do
        <<~HTML
          <a>
            Click Me
          </a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with url: value' do
      let(:component_options) { super().merge(url: 'www.example.com') }
      let(:snapshot) do
        <<~HTML
          <a href="www.example.com"></a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with typography options' do
      let(:component_options) { super().merge(size: 3) }
      let(:snapshot) do
        <<~HTML
          <a class="is-size-3"></a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          class_name: 'custom-class',
          color:      'indigo',
          icon:       { icon: 'rainbow', size: 'large' },
          target:     'blank',
          text:       'The More You Know',
          url:        'www.example.com',
          weight:     'bold'
        )
      end
      let(:snapshot) do
        <<~HTML
          <a class="icon-text has-text-indigo has-text-weight-bold custom-class" href="www.example.com" target="_blank">
            <span class="icon is-large">
              <i class="fa-solid fa-rainbow"></i>
            </span>

            The More You Know
          </a>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    context 'with configuration: { bulma_prefix: value }' do
      include_deferred 'with configuration', bulma_prefix: 'bulma-'

      describe 'with button: true' do
        let(:component_options) { super().merge(button: true) }
        let(:snapshot) do
          <<~HTML
            <a class="bulma-button"></a>
          HTML
        end

        it { expect(rendered.to_s).to match_snapshot }
      end

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            class_name: 'custom-class',
            color:      'indigo',
            icon:       { icon: 'rainbow', size: 'large' },
            target:     'blank',
            text:       'The More You Know',
            url:        'www.example.com',
            weight:     'bold'
          )
        end
        let(:snapshot) do
          <<~HTML
            <a class="bulma-icon-text bulma-has-text-indigo bulma-has-text-weight-bold custom-class" href="www.example.com" target="_blank">
              <span class="bulma-icon bulma-is-large">
                <i class="fa-solid fa-rainbow"></i>
              </span>

              The More You Know
            </a>
          HTML
        end

        it { expect(rendered.to_s).to match_snapshot }
      end
    end
  end
end
