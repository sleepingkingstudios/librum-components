# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Options::ValidationHelpers do
  subject(:helpers) { Spec::ValidatedComponent.new(configuration) }

  let(:configuration) do
    Librum::Components::Configuration.new(
      colors: %i[red orange yellow green blue indigo violet]
    )
  end

  example_class 'Spec::ValidatedComponent', Struct.new(:configuration) \
  do |klass|
    klass.include Librum::Components::Options::ValidationHelpers # rubocop:disable RSpec/DescribedClass
  end

  describe '::HTTP_METHODS' do
    let(:expected) { Set.new(%w[delete get head patch post put]) }

    include_examples 'should define immutable constant',
      :HTTP_METHODS,
      -> { an_instance_of(Set) }

    it { expect(described_class::HTTP_METHODS).to be == expected }
  end

  describe '#validate_color' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_color, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_color, nil)).to be nil }
    end

    describe 'with a value not in configuration.colors' do
      let(:color)   { 'aquamarine' }
      let(:message) { 'color is not a valid color name' }

      it { expect(helpers.send(:validate_color, color)).to be == message }

      describe 'with as: value' do
        let(:as)      { 'tint' }
        let(:message) { 'tint is not a valid color name' }

        it 'should return the error message' do
          expect(helpers.send(:validate_color, color, as:)).to be == message
        end
      end
    end

    describe 'with a value in configuration.colors' do
      let(:color) { 'indigo' }

      it { expect(helpers.send(:validate_color, color)).to be nil }
    end
  end

  describe '#validate_component' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_component, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_component, nil)).to be nil }
    end

    describe 'with an Object' do
      let(:message) { 'value is not a component or options Hash' }

      it 'should return the error message' do
        expect(helpers.send(:validate_component, Object.new.freeze))
          .to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'logo' }
        let(:message) { 'logo is not a component or options Hash' }

        it 'should return the error message' do
          expect(helpers.send(:validate_component, Object.new.freeze, as:))
            .to be == message
        end
      end
    end

    describe 'with a Hash' do
      it { expect(helpers.send(:validate_component, {})).to be nil }
    end

    describe 'with a component' do
      let(:component) { Librum::Components::Literal.new('<img />') }

      it { expect(helpers.send(:validate_component, component)).to be nil }
    end
  end

  describe '#validate_http_method' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_http_method, true)
        .with(1).argument
        .and_keywords(:as)
    end

    it { expect(helpers.send(:validate_http_method, nil)).to be nil }

    describe 'with an Object' do
      let(:value) { Object.new.freeze }
      let(:error_message) do
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.name',
            as: 'http_method'
          )
      end

      it 'should return the error message' do
        expect(helpers.send(:validate_http_method, value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'value' }
        let(:error_message) do
          SleepingKingStudios::Tools::Toolbelt
            .instance
            .assertions
            .error_message_for(
              'sleeping_king_studios.tools.assertions.name',
              as: 'value'
            )
        end

        it 'should return the error message' do
          expect(helpers.send(:validate_http_method, value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an empty String' do
      let(:value) { '' }
      let(:error_message) do
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.presence',
            as: 'http_method'
          )
      end

      it 'should return the error message' do
        expect(helpers.send(:validate_http_method, value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'value' }
        let(:error_message) do
          SleepingKingStudios::Tools::Toolbelt
            .instance
            .assertions
            .error_message_for(
              'sleeping_king_studios.tools.assertions.presence',
              as: 'value'
            )
        end

        it 'should return the error message' do
          expect(helpers.send(:validate_http_method, value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an empty Symbol' do
      let(:value) { :'' }
      let(:error_message) do
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.presence',
            as: 'http_method'
          )
      end

      it 'should return the error message' do
        expect(helpers.send(:validate_http_method, value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'value' }
        let(:error_message) do
          SleepingKingStudios::Tools::Toolbelt
            .instance
            .assertions
            .error_message_for(
              'sleeping_king_studios.tools.assertions.presence',
              as: 'value'
            )
        end

        it 'should return the error message' do
          expect(helpers.send(:validate_http_method, value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an invalid String' do
      let(:value) { 'explode' }
      let(:error_message) do
        'http_method is not a valid http method - valid values are ' \
          "#{described_class::HTTP_METHODS.map(&:upcase).join(', ')}"
      end

      it 'should return the error message' do
        expect(helpers.send(:validate_http_method, value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'value' }
        let(:error_message) do
          'value is not a valid http method - valid values are ' \
            "#{described_class::HTTP_METHODS.map(&:upcase).join(', ')}"
        end

        it 'should return the error message' do
          expect(helpers.send(:validate_http_method, value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with an invalid Symbol' do
      let(:value) { :explode }
      let(:error_message) do
        'http_method is not a valid http method - valid values are ' \
          "#{described_class::HTTP_METHODS.map(&:upcase).join(', ')}"
      end

      it 'should return the error message' do
        expect(helpers.send(:validate_http_method, value))
          .to be == error_message
      end

      describe 'with as: value' do
        let(:as) { 'value' }
        let(:error_message) do
          'value is not a valid http method - valid values are ' \
            "#{described_class::HTTP_METHODS.map(&:upcase).join(', ')}"
        end

        it 'should return the error message' do
          expect(helpers.send(:validate_http_method, value, as:))
            .to be == error_message
        end
      end
    end

    describe 'with a valid String' do
      let(:value) { 'DELETE' }

      it { expect(helpers.send(:validate_http_method, value)).to be nil }
    end

    describe 'with a valid Symbol' do
      let(:value) { :delete }

      it { expect(helpers.send(:validate_http_method, value)).to be nil }
    end
  end

  describe '#validate_icon' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_icon, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_icon, nil)).to be nil }
    end

    describe 'with an Object' do
      let(:message) { 'icon is not a valid icon' }

      it 'should return the error message' do
        expect(helpers.send(:validate_icon, Object.new.freeze)).to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'logo' }
        let(:message) { 'logo is not a valid icon' }

        it 'should return the error message' do
          expect(helpers.send(:validate_icon, Object.new.freeze, as:))
            .to be == message
        end
      end
    end

    describe 'with a String' do
      it { expect(helpers.send(:validate_icon, 'sigil')).to be nil }
    end

    describe 'with a Hash' do
      let(:message) { 'icon is not a valid icon' }

      it 'should return the error message' do
        expect(helpers.send(:validate_icon, {})).to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'logo' }
        let(:message) { 'logo is not a valid icon' }

        it 'should return the error message' do
          expect(helpers.send(:validate_icon, {}, as:)).to be == message
        end
      end
    end

    describe 'with a Hash with icon: value' do
      it { expect(helpers.send(:validate_icon, { icon: 'sigil' })).to be nil }
    end

    describe 'with a component' do
      let(:icon) { Librum::Components::Literal.new('<img />') }

      it { expect(helpers.send(:validate_icon, icon)).to be nil }
    end
  end

  describe '#validate_inclusion' do
    let(:expected) { %w[small medium large] }

    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_inclusion, true)
        .with(1).argument
        .and_keywords(:as, :expected)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_inclusion, nil, expected:)).to be nil }
    end

    describe 'with a value not in the list' do
      let(:value)   { 'miniature' }
      let(:message) { 'value is not included in the list' }

      it 'should return the error message' do
        expect(helpers.send(:validate_inclusion, value, expected:))
          .to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'size' }
        let(:message) { 'size is not included in the list' }

        it 'should return the error message' do
          expect(helpers.send(:validate_inclusion, value, as:, expected:))
            .to be == message
        end
      end
    end
  end

  describe '#validate_size' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_size, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_size, nil)).to be nil }
    end

    describe 'with a value not in configuration.sizes' do
      let(:size)    { 'imaginary' }
      let(:message) { 'size is not a valid size' }

      it { expect(helpers.send(:validate_size, size)).to be == message }

      describe 'with as: value' do
        let(:as)      { 'scale' }
        let(:message) { 'scale is not a valid size' }

        it 'should return the error message' do
          expect(helpers.send(:validate_size, size, as:)).to be == message
        end
      end
    end
  end
end
