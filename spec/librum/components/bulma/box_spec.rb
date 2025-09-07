# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Box, type: :component do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { {} }

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :class_name

  describe '.new' do
    include_deferred 'should validate the class_name option'
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <div class="box"></div>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with contents' do
      let(:contents) { 'Bigger on the inside?' }
      let(:rendered) { render_component(component) { contents } }
      let(:snapshot) do
        <<~HTML
          <div class="box">Bigger on the inside?</div>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <div class="box custom-class"></div>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end
  end
end
