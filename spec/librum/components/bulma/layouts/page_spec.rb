# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Layouts::Page,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'with configuration',
    colors:              %i[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component', layout: true

  include_deferred 'should define component option', :brand

  include_deferred 'should define component option',
    :color,
    value: 'red'

  include_deferred 'should define component option', :copyright

  include_deferred 'should define component option',
    :max_width,
    default: 'desktop'

  include_deferred 'should define component option',
    :navigation,
    value: [{ label: 'Home', url: '/' }]

  include_deferred 'should define component option', :tagline

  include_deferred 'should define component option', :title

  describe '.new' do
    include_deferred 'should validate that option is a valid color',
      :color
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:options_with_defaults) do
      { max_width: 'desktop' }.merge(component_options)
    end
    let(:render_alerts) do
      component = described_class::Alerts.new(alerts:)
      rendered  = pretty_render(component)

      indent(rendered, 4)
    end
    let(:render_header) do
      options   =
        options_with_defaults
        .slice(:brand, :color, :max_width, :navigation, :session, :title)
      component = described_class::Header.new(**options)

      pretty_render(component)
    end
    let(:render_footer) do
      options   = options_with_defaults.slice(:copyright, :max_width, :tagline)
      component = described_class::Footer.new(**options)

      pretty_render(component)
    end
    let(:snapshot) do
      <<~HTML
        #{render_header.strip}

        <main class="section pt-5" style="flex: 1;">
          <div class="container content is-max-desktop"></div>
        </main>
      HTML
    end

    define_method :indent do |str, count|
      offset = ' ' * count

      str
        .lines
        .map { |line| line.start_with?("\n") ? line : "#{offset}#{line}" }
        .join
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with content' do
      let(:content)   { 'Page Content' }
      let(:component) { super().with_content(content) }
      let(:snapshot) do
        <<~HTML
          #{render_header.strip}

          <main class="section pt-5" style="flex: 1;">
            <div class="container content is-max-desktop">
              Page Content
            </div>
          </main>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with alerts' do
        let(:alerts) do
          [
            {
              message: 'Reactor temperature critical',
              type:    'warning'
            },
            {
              icon:    'radiation',
              message: 'Meltdown imminent',
              type:    'danger'
            }
          ]
        end
        let(:component_options) { super().merge(alerts:) }
        let(:snapshot) do
          <<~HTML
            #{render_header.strip}

            <main class="section pt-5" style="flex: 1;">
              <div class="container content is-max-desktop">
                #{render_alerts.strip}

                Page Content
              </div>
            </main>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end
    end

    describe 'with alerts' do
      let(:alerts) do
        [
          {
            message: 'Reactor temperature critical',
            type:    'warning'
          },
          {
            icon:    'radiation',
            message: 'Meltdown imminent',
            type:    'danger'
          }
        ]
      end
      let(:component_options) { super().merge(alerts:) }
      let(:snapshot) do
        <<~HTML
          #{render_header.strip}

          <main class="section pt-5" style="flex: 1;">
            <div class="container content is-max-desktop">
              #{render_alerts.strip}
            </div>
          </main>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with options for the page header' do
      let(:component_options) do
        super().merge(
          brand:      { icon: 'radiation' },
          color:      'red',
          navigation: [{ label: 'Home', url: '/' }],
          session:    { user_name: 'Alan Bradley' },
          title:      'Example Company'
        )
      end
      let(:snapshot) do
        <<~HTML
          #{render_header.strip}

          <main class="section pt-5" style="flex: 1;">
            <div class="container content is-max-desktop"></div>
          </main>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with options for the page footer' do
      let(:component_options) do
        super().merge(
          copyright: { holder: 'Example Company', year: '1982' },
          tagline:   'We Do Company Things'
        )
      end
      let(:snapshot) do
        <<~HTML
          #{render_header.strip}

          <main class="section pt-5" style="flex: 1;">
            <div class="container content is-max-desktop"></div>
          </main>

          #{render_footer.strip}
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:content)   { 'Page Content' }
      let(:component) { super().with_content(content) }
      let(:component_options) do
        super().merge(
          brand:      { icon: 'radiation' },
          color:      'red',
          copyright:  { holder: 'Example Company', year: '1982' },
          max_width:  'tablet',
          navigation: [{ label: 'Home', url: '/' }],
          tagline:    'We Do Company Things',
          title:      'Example Company'
        )
      end
      let(:snapshot) do
        <<~HTML
          #{render_header.strip}

          <main class="section pt-5" style="flex: 1;">
            <div class="container content is-max-tablet">
              Page Content
            </div>
          </main>

          #{render_footer.strip}
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#session' do
    # Can't assert on #respond_to? because it delegates to the controller.
    it { expect(component.session).to be nil }

    describe 'with session: value' do
      let(:session)           { { user_name: 'Alan Bradley' } }
      let(:component_options) { super().merge(session:) }

      it { expect(component.session).to be session }
    end
  end
end
