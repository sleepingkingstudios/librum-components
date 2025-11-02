# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Header,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { max_width: 'desktop' } }

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

  include_deferred 'should define component option',
    :session_component,
    value: Class.new(ViewComponent::Base)

  include_deferred 'should define component option', :title

  describe '.new' do
    include_deferred 'should validate that option is a valid color',
      :color

    include_deferred 'should validate the type of option',
      :session_component,
      allow_nil: true,
      expected:  Class
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

    it { expect(rendered).to match_snapshot }

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

      it { expect(rendered).to match_snapshot }
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

      it { expect(rendered).to match_snapshot }
    end

    describe 'with session_component: value' do
      let(:session_component) { Spec::ExampleSession }
      let(:component_options) { super().merge(session_component:) }

      example_class 'Spec::ExampleSession', ViewComponent::Base do |klass|
        klass.define_method(:initialize) do |session: nil|
          @session = session
        end

        klass.attr_reader :session

        klass.define_method(:call) do
          "You are currently logged in as #{session.user_name}.".html_safe # rubocop:disable Rails/OutputSafety
        end

        klass.define_method(:render?) do
          session.present?
        end
      end

      it { expect(rendered).to match_snapshot }

      describe 'with session: value' do
        let(:session)           { Struct.new(:user_name).new('Alan Bradley') }
        let(:component_options) { super().merge(session:) }
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

            <div class="container is-max-desktop is-flex-grow-0 my-2">
              You are currently logged in as Alan Bradley.
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end
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

      it { expect(rendered).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:navigation) do
        [
          { label: 'Home',    url: '/' },
          { label: 'Widgets', url: '/widgets' }
        ]
      end
      let(:session)           { Struct.new(:user_name).new('Alan Bradley') }
      let(:session_component) { Spec::ExampleSession }
      let(:component_options) do
        super().merge(
          brand:             { icon: 'radiation' },
          color:             'red',
          max_width:         'tablet',
          navigation:,
          session:,
          session_component:,
          title:             'Example Company'
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

          <div class="container is-max-tablet is-flex-grow-0 my-2">
            You are currently logged in as Alan Bradley.
          </div>
        HTML
      end

      example_class 'Spec::ExampleSession', ViewComponent::Base do |klass|
        klass.define_method(:initialize) do |session: nil|
          @session = session
        end

        klass.attr_reader :session

        klass.define_method(:call) do
          "You are currently logged in as #{session.user_name}.".html_safe # rubocop:disable Rails/OutputSafety
        end

        klass.define_method(:render?) do
          session.present?
        end
      end

      it { expect(rendered).to match_snapshot }
    end
  end

  describe '#session' do
    # Can't assert on #respond_to? because it delegates to the controller.
    it { expect(component.session).to be nil }

    describe 'with session: value' do
      let(:session)           { Struct.new(:user_name).new('Alan Bradley') }
      let(:component_options) { super().merge(session:) }

      it { expect(component.session).to be == session }
    end
  end
end
