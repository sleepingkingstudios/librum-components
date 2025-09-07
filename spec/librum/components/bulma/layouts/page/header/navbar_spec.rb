# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Header::Navbar,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :navigation,
    value: [{ label: 'Home', url: '/' }]

  describe '.new' do
    include_deferred 'should validate that option is a valid array',
      :navigation,
      invalid_item: Object.new.freeze,
      item_message: 'is not an instance of Hash',
      valid_items:  [{ icon: 'left-arrow' }, { icon: 'right-arrow' }]
  end

  describe '#call' do
    let(:rendered) { render_component(component) }

    describe 'with navigation: a non-empty Array' do
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
          <div id="primary-navigation" class="navbar-menu" data-librum-components-navbar-target="menu">
            <div class="navbar-start has-text-weight-semibold">
              <a href="/" class="navbar-item">
                Home
              </a>

              <a href="/widgets" class="navbar-item">
                Widgets
              </a>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end

  describe '#render?' do
    it { expect(component.render?).to be false }

    describe 'with navigation: an empty Array' do
      let(:component_options) do
        super().merge(navigation: [])
      end

      it { expect(component.render?).to be false }
    end

    describe 'with navigation: a non-empty Array' do
      let(:navigation) do
        [
          { label: 'Home',    url: '/' },
          { label: 'Widgets', url: '/widgets' }
        ]
      end
      let(:component_options) do
        super().merge(navigation:)
      end

      it { expect(component.render?).to be true }
    end
  end
end
