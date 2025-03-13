# frozen_string_literal: true

require 'librum/components/icons/font_awesome'

require 'support/deferred/component_examples'

RSpec.describe Librum::Components::Icons::FontAwesome, type: :component do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:family) { 'font-awesome-solid' }
  let(:icon)   { 'rainbow' }
  let(:component_options) do
    { family:, icon: }
  end

  include_deferred 'should be a view component'

  describe '::ICON_FAMILIES' do
    include_examples 'should define frozen constant',
      :ICON_FAMILIES,
      lambda {
        Set.new(
          %w[
            fa
            fa-brands
            fa-solid
            fas
            font-awesome
            font-awesome-brands
            font-awesome-solid
          ]
        )
      }
  end

  describe '.new' do
    include_deferred 'should validate the presence of option',
      :family,
      string: true

    include_deferred 'should validate the presence of option',
      :icon,
      string: true

    describe 'with family: an invalid value' do
      let(:family)        { 'bootstrap' }
      let(:error_message) { 'family is not a FontAwesome icon family' }

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error Librum::Components::Options::InvalidOptionsError,
            error_message
      end
    end
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <i class="fa-solid fa-rainbow"></i>
      HTML
    end

    it { expect(rendered.to_s).to match_snapshot }

    describe 'with family: brands' do
      let(:family) { 'font-awesome-brands' }
      let(:icon)   { 'github' }
      let(:snapshot) do
        <<~HTML
          <i class="fa-brands fa-github"></i>
        HTML
      end

      it { expect(rendered.to_s).to match_snapshot }
    end
  end
end
