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

  describe '#remote_forms' do
    include_examples 'should define reader', :remote_forms, nil

    context 'when initialized with remote_forms: false' do
      let(:constructor_options) { super().merge(remote_forms: false) }

      it { expect(resource.remote_forms).to be false }
    end

    context 'when initialized with remote_forms: true' do
      let(:constructor_options) { super().merge(remote_forms: true) }

      it { expect(resource.remote_forms).to be true }
    end
  end

  describe '#title_attribute' do
    include_examples 'should define reader', :title_attribute, nil

    context 'when initialized with title_attribute: value' do
      let(:constructor_options) { super().merge(title_attribute: 'label') }

      it { expect(resource.title_attribute).to be == 'label' }
    end
  end
end
