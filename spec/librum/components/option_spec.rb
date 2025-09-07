# frozen_string_literal: true

require 'librum/components'

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

  describe '#required?' do
    include_examples 'should define predicate', :required?, false

    context 'when initialized with required: false' do
      let(:options) { super().merge(required: false) }

      it { expect(option.required?).to be false }
    end

    context 'when initialized with required: true' do
      let(:options) { super().merge(required: true) }

      it { expect(option.required?).to be true }
    end
  end

  describe '#to_h' do
    let(:expected) do
      {
        boolean:  option.boolean,
        default:  option.default,
        name:     option.name,
        required: option.required,
        validate: option.validate
      }
    end

    it { expect(option.to_h).to be == expected }

    it { expect(option).to have_aliased_method(:to_h).as(:to_hash) }

    context 'when initialized with boolean: true' do
      let(:options) { super().merge(boolean: true) }

      it { expect(option.to_h).to be == expected }
    end

    context 'when initialized with default: a value' do
      let(:default) { 'value' }
      let(:options) { super().merge(default:) }

      it { expect(option.to_h).to be == expected }
    end

    context 'when initialized with required: true' do
      let(:options) { super().merge(required: true) }

      it { expect(option.to_h).to be == expected }
    end

    context 'when initialized with validate: a value' do
      let(:validate) { :present }
      let(:options)  { super().merge(validate:) }

      it { expect(option.to_h).to be == expected }
    end
  end

  describe '#validate' do
    include_examples 'should define reader', :validate, nil

    context 'when initialized with validate: a Proc' do
      let(:validate) do
        lambda do |_|
          # :nocov:
          next unless validate.nil?

          "option can't be blank"
          # :nocov:
        end
      end
      let(:options) { super().merge(validate:) }

      it { expect(option.validate).to be validate }
    end

    context 'when initialized with validate: a Class' do
      let(:validate) { Integer }
      let(:options)  { super().merge(validate:) }

      it { expect(option.validate).to be validate }
    end

    context 'when initialized with validate: a Symbol' do
      let(:validate) { :present }
      let(:options)  { super().merge(validate:) }

      it { expect(option.validate).to be validate }
    end
  end

  describe '#validate?' do
    include_examples 'should define predicate', :validate?, false

    context 'when initialized with validate: a Proc' do
      let(:validate) do
        lambda do |_|
          # :nocov:
          next unless validate.nil?

          "option can't be blank"
          # :nocov:
        end
      end
      let(:options) { super().merge(validate:) }

      it { expect(option.validate?).to be true }
    end

    context 'when initialized with validate: a Class' do
      let(:validate) { Integer }
      let(:options)  { super().merge(validate:) }

      it { expect(option.validate?).to be true }
    end

    context 'when initialized with validate: a Symbol' do
      let(:validate) { :present }
      let(:options)  { super().merge(validate:) }

      it { expect(option.validate?).to be true }
    end
  end
end
