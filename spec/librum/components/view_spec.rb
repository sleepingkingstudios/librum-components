# frozen_string_literal: true

require 'cuprum'
require 'cuprum/rails'

require 'librum/components'

RSpec.describe Librum::Components::View, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:result)            { Cuprum::Result.new }
  let(:required_keywords) { { result: } }

  include_deferred 'should be an abstract view component',
    described_class,
    has_required_keywords: true

  describe '#error' do
    include_examples 'should define reader', :error, nil

    context 'when initialized with a result with an error' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong') }
      let(:result) { Cuprum::Result.new(error:) }

      it { expect(component.error).to be error }
    end
  end

  describe '#metadata' do
    include_examples 'should define reader', :metadata, {}

    context 'when initialized with a web result' do
      let(:result) { Cuprum::Rails::Result.new }

      it { expect(component.metadata).to be == {} }
    end

    context 'when initialized with a web result with metadata' do
      let(:metadata) do
        { 'action_name' => 'publish', 'controller_name' => 'books' }
      end
      let(:result) { Cuprum::Rails::Result.new(metadata:) }

      it { expect(component.metadata).to be == result.metadata }
    end
  end

  describe '#resource' do
    include_examples 'should define reader', :resource, nil

    context 'when initialized with a resource' do
      let(:resource) { Cuprum::Rails::Resource.new(name: 'books') }
      let(:component_options) do
        super().merge(resource:)
      end

      it { expect(component.resource).to be resource }
    end
  end

  describe '#result' do
    include_examples 'should define reader', :result, -> { result }
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { result.status }

    context 'when initialized with a result with status: :failure' do
      let(:result) { Cuprum::Result.new(status: :failure) }

      it { expect(component.status).to be :failure }
    end
  end

  describe '#value' do
    include_examples 'should define reader', :value, nil

    context 'when initialized with a result with a value' do
      let(:value)  { { ok: true } }
      let(:result) { Cuprum::Result.new(value:) }

      it { expect(component.value).to be value }
    end
  end
end
