# frozen_string_literal: true

require 'librum/components/bulma/page/footer'

require 'support/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Page::Footer, type: :component do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options)   { { max_width: 'desktop' } }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :copyright

  include_deferred 'should define component option', :max_width

  include_deferred 'should define component option', :tagline

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:render_copyright) do
      options   = component_options[:copyright]
      component = described_class::Copyright.new(**options)

      pretty_render(component)
    end

    describe 'with copyright: a non-empty Hash' do
      let(:component_options) do
        super().merge(copyright: { holder: 'Example Company', year: '1982' })
      end
      let(:snapshot) do
        <<~HTML
          <footer>
            <div class="footer">
              <div class="container is-max-desktop">
                #{render_copyright.then { |s| pad(s, 6) }}
              </div>
            </div>
          </footer>
        HTML
      end

      include_deferred 'with configuration',
        default_icon_family: 'fa-solid',
        icon_families:       %i[fa-solid]

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with tagline: a non-empty String' do
      let(:component_options) do
        super().merge(tagline: 'We Do Company Things')
      end
      let(:snapshot) do
        <<~HTML
          <footer>
            <div class="footer">
              <div class="container is-max-desktop">
                <p class="has-text-centered is-italic mt-1">
                  We Do Company Things
                </p>
              </div>
            </div>
          </footer>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          copyright: { holder: 'Example Company', year: '1982' },
          max_width: 'tablet',
          tagline:   'We Do Company Things'
        )
      end
      let(:snapshot) do
        <<~HTML
          <footer>
            <div class="footer">
              <div class="container is-max-tablet">
                #{render_copyright.then { |s| pad(s, 6) }}

                <p class="has-text-centered is-italic mt-1">
                  We Do Company Things
                </p>
              </div>
            </div>
          </footer>
        HTML
      end

      include_deferred 'with configuration',
        default_icon_family: 'fa-solid',
        icon_families:       %i[fa-solid]

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#render?' do
    it { expect(component.render?).to be false }

    describe 'with copyright: an empty Hash' do
      let(:component_options) do
        super().merge(copyright: {})
      end

      it { expect(component.render?).to be false }
    end

    describe 'with copyright: a non-empty Hash' do
      let(:component_options) do
        super().merge(copyright: { holder: 'Example Company', year: '1982' })
      end

      it { expect(component.render?).to be true }
    end

    describe 'with tagline: an empty String' do
      let(:component_options) do
        super().merge(tagline: '')
      end

      it { expect(component.render?).to be false }
    end

    describe 'with tagline: a non-empty String' do
      let(:component_options) do
        super().merge(tagline: 'We Do Company Things')
      end

      it { expect(component.render?).to be true }
    end
  end
end
