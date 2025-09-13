# frozen_string_literal: true

require 'cuprum/rails/rspec/deferred/resource_examples'

require 'librum/components/resource'

require 'support/book'
require 'support/tome'

RSpec.describe Librum::Components::Resource do
  include Cuprum::Rails::RSpec::Deferred::ResourceExamples

  subject(:resource) { described_class.new(**constructor_options) }

  let(:name)                { 'books' }
  let(:constructor_options) { { name: } }

  include_deferred 'should be a Rails Resource'

  describe '#components' do
    include_examples 'should define reader',
      :components,
      Librum::Components::Empty

    context 'when initialized with components: value' do
      let(:components)          { Spec::Books::Components }
      let(:constructor_options) { super().merge(components:) }

      example_constant 'Spec::Books::Components', Module.new

      it { expect(resource.components).to be components }
    end
  end
end
