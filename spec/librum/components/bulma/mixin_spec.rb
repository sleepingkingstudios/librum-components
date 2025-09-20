# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Mixin,
  framework: :bulma,
  type:      :component \
do
  let(:described_class) { Spec::BulmaComponent }

  example_class 'Spec::BulmaComponent', Librum::Components::Base do |klass|
    klass.include Librum::Components::Bulma::Mixin # rubocop:disable RSpec/DescribedClass
  end

  include_deferred 'should be a view component'

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

  describe '#components' do
    it { expect(component.components).to be Librum::Components::Bulma }

    context 'when the components are defined' do
      example_constant 'Spec::Components'

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      it { expect(component.components).to be Spec::Components }
    end
  end

  describe '#configuration' do
    let(:expected) { Librum::Components::Bulma::Configuration.default }

    it { expect(component.configuration).to be == expected }

    context 'when the configuration is defined' do
      let(:configuration) { Librum::Components::Bulma::Configuration.new }

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :configuration,
          configuration
        )
      end

      it { expect(component.configuration).to be == configuration }
    end
  end
end
