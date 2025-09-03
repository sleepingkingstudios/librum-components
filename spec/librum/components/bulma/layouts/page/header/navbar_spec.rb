# frozen_string_literal: true

require 'librum/components/bulma/layouts/page/header/navbar'
require 'librum/components/rspec/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Header::Navbar,
  type: :component \
do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options)   { {} }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :navigation,
    value: [{ label: 'Home', url: '/' }]

  describe '.new' do
    describe 'with navigation: an Object' do
      let(:component_options) do
        super().merge(navigation: Object.new.freeze)
      end
      let(:error_message) do
        'navigation is not an Array'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }.to raise_error(
          Librum::Components::Options::InvalidOptionsError,
          error_message
        )
      end
    end

    describe 'with navigation: an Array with invalid items' do
      let(:navigation) do
        [
          { label: 'Home', url: '/' },
          Object.new.freeze,
          { label: 'Widgets', url: '/widgets' }
        ]
      end
      let(:component_options) do
        super().merge(navigation:)
      end
      let(:error_message) do
        'navigation item 1 is not a Hash'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }.to raise_error(
          Librum::Components::Options::InvalidOptionsError,
          error_message
        )
      end
    end
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
