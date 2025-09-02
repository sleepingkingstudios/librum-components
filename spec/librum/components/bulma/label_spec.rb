# frozen_string_literal: true

require 'librum/components/bulma/label'
require 'librum/components/rspec/deferred/bulma_examples'
require 'librum/components/rspec/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Label, type: :component do
  include Librum::Components::RSpec::Deferred::BulmaExamples
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options)   { {} }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'with configuration',
    colors:              %i[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component'

  include_deferred 'should define typography options'

  include_deferred 'should define component option', :class_name

  include_deferred 'should define component option',
    :color,
    value: 'indigo'

  include_deferred 'should define component option', :icon

  include_deferred 'should define component option',
    :tag,
    default: 'span',
    value:   'div'

  include_deferred 'should define component option', :text

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid color',
      :color

    include_deferred 'should validate that option is a valid icon', :icon

    include_deferred 'should validate the inclusion of option',
      :tag,
      expected: %w[div span]
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <span>
        </span>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <span class="custom-class">
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'indigo') }
      let(:snapshot) do
        <<~HTML
          <span class="has-text-indigo">
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with icon: value' do
      let(:component_options) { super().merge(icon: 'rainbow') }
      let(:snapshot) do
        <<~HTML
          <span class="icon-text">
            <span class="icon">
              <i class="fa-solid fa-rainbow"></i>
            </span>
          </span>
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
          <span class="icon-text">
            <span class="icon">
              <i class="fa-solid fa-rainbow"></i>
            </span>

            The More You Know
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with tag: div' do
      let(:component_options) { super().merge(tag: 'div') }
      let(:snapshot) do
        <<~HTML
          <div>
          </div>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with text: value' do
      let(:component_options) { super().merge(text: 'The More You Know') }
      let(:snapshot) do
        <<~HTML
          <span>
            The More You Know
          </span>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with typography options' do
      let(:component_options) { super().merge(size: 3) }
      let(:snapshot) do
        <<~HTML
          <span class="is-size-3">
          </span>
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
          tag:        'div',
          text:       'The More You Know',
          weight:     'bold'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="icon-text has-text-indigo has-text-weight-bold custom-class">
            <span class="icon is-large">
              <i class="fa-solid fa-rainbow"></i>
            </span>

            The More You Know
          </div>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    context 'with configuration: { bulma_prefix: value }' do
      include_deferred 'with configuration', bulma_prefix: 'bulma-'

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            class_name: 'custom-class',
            color:      'indigo',
            icon:       { icon: 'rainbow', size: 'large' },
            tag:        'div',
            text:       'The More You Know',
            weight:     'bold'
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="bulma-icon-text bulma-has-text-indigo bulma-has-text-weight-bold custom-class">
              <span class="bulma-icon bulma-is-large">
                <i class="fa-solid fa-rainbow"></i>
              </span>

              The More You Know
            </div>
          HTML
        end

        it { expect(rendered.to_s).to match_snapshot }
      end
    end
  end
end
