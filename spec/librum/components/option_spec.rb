# frozen_string_literal: true

require 'librum/components/option'

RSpec.describe Librum::Components::Option do
  subject(:option) { described_class.new(name:, **options) }

  let(:name)    { 'example_option' }
  let(:options) { {} }

  describe '#boolean?' do
    include_examples 'should define predicate', :boolean?, false

    context 'when initialized with boolean: false' do
      let(:options) { super().merge(boolean: false) }

      it { expect(option.boolean?).to be false }
    end

    context 'when initialized with boolean: true' do
      let(:options) { super().merge(boolean: true) }

      it { expect(option.boolean?).to be true }
    end
  end

  describe '#default' do
    include_examples 'should define reader', :default, nil

    context 'when initialized with default: a Proc' do
      let(:default) { -> { 'value' } }
      let(:options) { super().merge(default:) }

      it { expect(option.default).to be default }
    end

    context 'when initialized with default: a value' do
      let(:default) { 'value' }
      let(:options) { super().merge(default:) }

      it { expect(option.default).to be default }
    end
  end

  describe '#default?' do
    include_examples 'should define predicate', :default?, false

    context 'when initialized with default: a Proc' do
      let(:default) { -> { 'value' } }
      let(:options) { super().merge(default:) }

      it { expect(option.default?).to be true }
    end

    context 'when initialized with default: a value' do
      let(:default) { 'value' }
      let(:options) { super().merge(default:) }

      it { expect(option.default?).to be true }
    end
  end

  describe '#name' do
    include_examples 'should define reader', :name, -> { name }
  end
end
