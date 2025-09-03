# frozen_string_literal: true

require 'librum/components/bulma/layouts/page/footer/copyright'
require 'librum/components/rspec/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Footer::Copyright,
  type: :component \
do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      holder: 'Example Company',
      year:   '1982'
    }
  end
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'with configuration',
    default_icon_family: 'fa-solid',
    icon_families:       %i[fa-solid]

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :holder

  include_deferred 'should define component option', :scope

  include_deferred 'should define component option', :year

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <p class="has-text-centered">
          <span class="icon-text">
            <span class="icon">
              <i class="fa-solid fa-copyright"></i>
            </span>

            Example Company 1982
          </span>
        </p>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with scope: value' do
      let(:component_options) { super().merge(scope: 'Secret Project') }
      let(:snapshot) do
        <<~HTML
          <p class="has-text-centered">
            <span class="icon-text">
              Secret Project is

              <span class="icon">
                <i class="fa-solid fa-copyright"></i>
              </span>

              Example Company 1982
            </span>
          </p>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end
  end

  describe '#render?' do
    it { expect(component.render?).to be true }

    context 'when initialized with holder: nil' do
      let(:component_options) { super().merge(holder: nil) }

      it { expect(component.render?).to be false }
    end

    context 'when initialized with holder: an empty String' do
      let(:component_options) { super().merge(holder: '') }

      it { expect(component.render?).to be false }
    end

    context 'when initialized with year: nil' do
      let(:component_options) { super().merge(year: nil) }

      it { expect(component.render?).to be false }
    end

    context 'when initialized with year: an empty String' do
      let(:component_options) { super().merge(year: '') }

      it { expect(component.render?).to be false }
    end
  end
end
