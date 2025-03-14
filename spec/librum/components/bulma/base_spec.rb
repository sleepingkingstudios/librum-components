# frozen_string_literal: true

require 'librum/components/bulma/base'

RSpec.describe Librum::Components::Bulma::Base do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { {} }

  include_deferred 'should be an abstract view component', described_class

  describe '#bulma_class_names' do
    let(:arguments) { [] }
    let(:output)    { component.bulma_class_names(*arguments) }

    it 'should define the method' do
      expect(component)
        .to respond_to(:bulma_class_names)
        .with(0).arguments
        .and_unlimited_arguments
    end

    it { expect(output).to be == '' }

    describe 'with string arguments' do
      let(:arguments) { ['title', 'has-text-danger has-text-weight-bold'] }
      let(:expected)  { 'title has-text-danger has-text-weight-bold' }

      it { expect(output).to be == expected }
    end

    context 'when the configured bulma prefix is non-empty' do
      include_deferred 'with configuration', bulma_prefix: 'bulma-'

      it { expect(output).to be == '' }

      describe 'with string arguments' do
        let(:arguments) { ['title', 'has-text-danger has-text-weight-bold'] }
        let(:expected) do
          'bulma-title bulma-has-text-danger bulma-has-text-weight-bold'
        end

        it { expect(output).to be == expected }
      end
    end
  end
end
