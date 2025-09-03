# frozen_string_literal: true

require 'librum/components/bulma/layouts/page/header/navbar_item'
require 'librum/components/rspec/deferred/component_examples'

RSpec.describe Librum::Components::Bulma::Layouts::Page::Header::NavbarItem,
  type: :component \
do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) do
    {
      label: 'Click Me',
      url:   '/path/to/resource'
    }
  end
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :label

  include_deferred 'should define component option', :url

  describe '.new' do
    include_deferred 'should validate the presence of option',
      :label,
      string: true

    include_deferred 'should validate the presence of option',
      :url,
      string: true
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <a href="/path/to/resource" class="navbar-item">
          Click Me
        </a>
      HTML
    end

    it { expect(rendered).to match_snapshot }
  end
end
