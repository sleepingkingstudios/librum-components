# frozen_string_literal: true

require 'librum/components/bulma/page/header'
require 'librum/components/literal'

require 'support/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Page::Header, type: :component do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options)   { { max_width: 'desktop' } }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'with configuration',
    colors:              %i[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :brand

  include_deferred 'should define component option',
    :color,
    value: 'red'

  include_deferred 'should define component option',
    :max_width,
    default: 'desktop'

  include_deferred 'should define component option',
    :navigation,
    value: [{ label: 'Home', url: '/' }]

  include_deferred 'should define component option', :title

  describe '.new' do
    include_deferred 'should validate that option is a valid color',
      :color
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:render_brand) do
      options   = component_options.slice(:brand, :title)
      component = described_class::Brand.new(**options)

      pretty_render(component)
    end
    let(:render_navbar) do
      options   = component_options.slice(:navigation)
      component = described_class::Navbar.new(**options)

      pretty_render(component)
    end
    let(:snapshot) do
      <<~HTML
        <nav class="navbar" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
          <div class="container is-max-desktop">
            <div class="navbar-brand">
              <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                <span aria-hidden="true"></span>

                <span aria-hidden="true"></span>

                <span aria-hidden="true"></span>

                <span aria-hidden="true"></span>
              </a>
            </div>
          </div>
        </nav>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with brand: value' do
      let(:component_options) do
        super().merge(brand: { icon: 'radiation' })
      end
      let(:snapshot) do
        <<~HTML
          <nav class="navbar" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
            <div class="container is-max-desktop">
              <div class="navbar-brand">
                #{render_brand.then { |s| pad(s, 6) }}

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>
                </a>
              </div>
            </div>
          </nav>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with navigation: value' do
      let(:navigation) do
        [
          { label: 'Home',    url: '/' },
          { label: 'Widgets', url: '/widgets' }
        ]
      end
      let(:component_options) do
        super().merge(navigation:)
      end
      let(:snapshot) do
        <<~HTML
          <nav class="navbar" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
            <div class="container is-max-desktop">
              <div class="navbar-brand">
                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>
                </a>
              </div>

              #{render_navbar.then { |s| pad(s, 4) }}
            </div>
          </nav>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with title: value' do
      let(:component_options) do
        super().merge(title: 'Example Company')
      end
      let(:snapshot) do
        <<~HTML
          <nav class="navbar" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
            <div class="container is-max-desktop">
              <div class="navbar-brand">
                #{render_brand.then { |s| pad(s, 6) }}

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>
                </a>
              </div>
            </div>
          </nav>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:navigation) do
        [
          { label: 'Home',    url: '/' },
          { label: 'Widgets', url: '/widgets' }
        ]
      end
      let(:component_options) do
        super().merge(
          brand:      { icon: 'radiation' },
          color:      'red',
          max_width:  'tablet',
          navigation:,
          title:      'Example Company'
        )
      end
      let(:snapshot) do
        <<~HTML
          <nav class="navbar is-red" role="navigation" aria-label="main navigation" data-controller="librum-components-navbar">
            <div class="container is-max-tablet">
              <div class="navbar-brand">
                #{render_brand.then { |s| pad(s, 6) }}

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-action="click->librum-components-navbar#toggle" data-librum-components-navbar-target="button">
                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>

                  <span aria-hidden="true"></span>
                </a>
              </div>

              #{render_navbar.then { |s| pad(s, 4) }}
            </div>
          </nav>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end
  end
end
