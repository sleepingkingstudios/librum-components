# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Header::Brand,
  framework: :bulma,
  type:      :component \
do
  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :brand,
    value: { icon: 'radiation' }

  include_deferred 'should define component option', :title

  describe '.new' do
    describe 'with brand: an Object' do
      let(:component_options) { super().merge(brand: Object.new.freeze) }
      let(:error_message) do
        'brand is not a Hash or a Component'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error(
            Librum::Components::Errors::InvalidOptionsError,
            error_message
          )
      end
    end
  end

  describe '#call' do
    let(:rendered) { render_component(component) }

    describe 'with brand: a Component' do
      let(:brand) do
        Librum::Components::Literal.new('<span>Brand</span>')
      end
      let(:component_options) { super().merge(brand:) }
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <span>
              Brand
            </span>
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with brand: an icon' do
      let(:brand) { { icon: 'radiation' } }
      let(:component_options) { super().merge(brand:) }
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <span class="icon">
              <i class="fa-solid fa-radiation fa-2xl"></i>
            </span>
          </a>
        HTML
      end

      include_deferred 'with configuration',
        default_icon_family: 'fa-solid',
        icon_families:       %i[fa-solid]

      it { expect(rendered).to match_snapshot }
    end

    describe 'with brand: an icon with options' do
      let(:brand) { { icon: 'radiation', color: 'indigo', size: '2x' } }
      let(:component_options) { super().merge(brand:) }
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <span class="icon has-text-indigo">
              <i class="fa-solid fa-radiation fa-2x"></i>
            </span>
          </a>
        HTML
      end

      include_deferred 'with configuration',
        colors:              %i[red orange yellow green blue indigo violet],
        default_icon_family: 'fa-solid',
        icon_families:       %i[fa-solid]

      it { expect(rendered).to match_snapshot }
    end

    describe 'with brand: an image path' do
      let(:brand) { { image_path: '/path/to/image.png' } }
      let(:component_options) { super().merge(brand:) }
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <figure class="image is-32x32">
              <img alt="Home Page" src="/path/to/image.png">
            </figure>
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with brand: an empty Hash and title: value' do
      let(:component_options) do
        super().merge(brand: {}, title: 'Example Company')
      end
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <span class="title is-size-4">
              Example Company
            </span>
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with title: value' do
      let(:component_options) { super().merge(title: 'Example Company') }
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <span class="title is-size-4">
              Example Company
            </span>
          </a>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:brand) { { icon: 'radiation' } }
      let(:component_options) do
        super().merge(brand:, title: 'Example Company')
      end
      let(:snapshot) do
        <<~HTML
          <a class="navbar-item" href="/">
            <span class="icon">
              <i class="fa-solid fa-radiation fa-2xl"></i>
            </span>

            <span class="title is-size-4">
              Example Company
            </span>
          </a>
        HTML
      end

      include_deferred 'with configuration',
        default_icon_family: 'fa-solid',
        icon_families:       %i[fa-solid]

      it { expect(rendered).to match_snapshot }

      wrap_deferred 'with routes', root_path: '/path/to/root' do
        let(:snapshot) do
          <<~HTML
            <a class="navbar-item" href="/path/to/root">
              <span class="icon">
                <i class="fa-solid fa-radiation fa-2xl"></i>
              </span>

              <span class="title is-size-4">
                Example Company
              </span>
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end
    end
  end

  describe '#render?' do
    it { expect(component.render?).to be false }

    describe 'with brand: an empty Hash' do
      let(:component_options) { super().merge(brand: {}) }

      it { expect(component.render?).to be false }
    end

    describe 'with brand: a non-empty Hash' do
      let(:component_options) { super().merge(brand: { icon: 'radiation' }) }

      it { expect(component.render?).to be true }
    end

    describe 'with title: an empty String' do
      let(:component_options) { super().merge(title: '') }

      it { expect(component.render?).to be false }
    end

    describe 'with title: a non-empty String' do
      let(:component_options) { super().merge(title: 'Example Company') }

      it { expect(component.render?).to be true }
    end
  end
end
