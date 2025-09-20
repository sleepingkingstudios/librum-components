# frozen_string_literal: true

require 'stannum/errors'

require 'librum/components'

RSpec.describe Librum::Components::Form, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  let(:result)            { Cuprum::Rails::Result.new }
  let(:required_keywords) { { result: } }

  include_deferred 'should be a view component',
    has_required_keywords: true

  include_deferred 'should define component option', :action

  include_deferred 'should define component option',
    :http_method,
    value: 'get'

  describe '.new' do
    define_method :validate_options do
      described_class.new(**required_keywords, **component_options)
    end

    include_deferred 'should validate the type of option',
      :action,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate that option is a valid http method',
      :http_method
  end

  describe '#errors_for' do
    it { expect(component).to respond_to(:errors_for).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.name',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for(Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for('') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Symbol' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.errors_for(:'') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a non-matching String' do
      it { expect(component.errors_for('invalid')).to be == [] }
    end

    describe 'with a non-matching Symbol' do
      it { expect(component.errors_for(:invalid)).to be == [] }
    end

    context 'when the result has an error' do
      let(:error)  { Cuprum::Error.new(message: 'Something went wrong.') }
      let(:result) { Cuprum::Result.new(error:) }

      describe 'with a non-matching String' do
        it { expect(component.errors_for('invalid')).to be == [] }
      end

      describe 'with a non-matching Symbol' do
        it { expect(component.errors_for(:invalid)).to be == [] }
      end
    end

    context 'when the result has an error with an errors object' do
      let(:errors) do
        Stannum::Errors.new.tap do |err|
          err['launch_site'].add('not_ready', message: 'is not ready')
          err['rocket']['name'].add('taken')
          err['rocket']['fuel']['amount'].add('empty',   message: 'is empty')
          err['rocket']['fuel']['amount'].add('invalid', message: 'is invalid')
        end
      end
      let(:error)  { Struct.new(:errors).new(errors) }
      let(:result) { Cuprum::Result.new(error:) }

      describe 'with a non-matching String' do
        it { expect(component.errors_for('invalid')).to be == [] }
      end

      describe 'with a non-matching Symbol' do
        it { expect(component.errors_for(:invalid)).to be == [] }
      end

      describe 'with a matching String' do
        let(:expected) { ['is not ready'] }

        it { expect(component.errors_for('launch_site')).to be == expected }
      end

      describe 'with a matching Symbol' do
        let(:expected) { ['is not ready'] }

        it { expect(component.errors_for(:launch_site)).to be == expected }
      end

      describe 'with a non-matching bracket-separated path' do
        it { expect(component.errors_for('rocket[manufacturer]')).to be == [] }
      end

      describe 'with a matching bracket-separated path' do
        let(:expected) { ['is empty', 'is invalid'] }

        it 'should find the nested errors' do
          expect(component.errors_for('rocket[fuel][amount]')).to be == expected
        end
      end

      describe 'with a non-matching dot-separated path' do
        it { expect(component.errors_for('rocket.manufacturer')).to be == [] }
      end

      describe 'with a matching dot-separated path' do
        let(:expected) { ['is empty', 'is invalid'] }

        it 'should find the nested errors' do
          expect(component.errors_for('rocket.fuel.amount')).to be == expected
        end
      end
    end
  end

  describe '#result' do
    include_examples 'should define reader', :result, -> { result }
  end

  describe '#value_for' do
    it { expect(component).to respond_to(:value_for).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.name',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for(Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for('') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Symbol' do
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'path'
        )
      end

      it 'should raise an exception' do
        expect { component.value_for(:'') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a non-matching String' do
      it { expect(component.value_for('invalid')).to be nil }
    end

    describe 'with a non-matching Symbol' do
      it { expect(component.value_for(:invalid)).to be nil }
    end

    context 'when the result has a value' do
      let(:value) do
        {
          'launch_site' => 'KSC',
          'rocket'      => {
            'name' => 'Imp VI',
            'fuel' => Struct.new(:amount).new('0.0')
          }
        }
      end
      let(:result) { Cuprum::Result.new(value:) }

      describe 'with a non-matching String' do
        it { expect(component.value_for('invalid')).to be nil }
      end

      describe 'with a non-matching Symbol' do
        it { expect(component.value_for(:invalid)).to be nil }
      end

      describe 'with a matching String' do
        it { expect(component.value_for('launch_site')).to be == 'KSC' }
      end

      describe 'with a matching Symbol' do
        it { expect(component.value_for(:launch_site)).to be == 'KSC' }
      end

      describe 'with a non-matching bracket-separated path' do
        it { expect(component.value_for('rocket[manufacturer]')).to be nil }
      end

      describe 'with a matching bracket-separated path' do
        it 'should find the nested value' do
          expect(component.value_for('rocket[fuel][amount]')).to be == '0.0'
        end
      end

      describe 'with a non-matching dot-separated path' do
        it { expect(component.value_for('rocket.manufacturer')).to be nil }
      end

      describe 'with a matching dot-separated path' do
        it 'should find the nested value' do
          expect(component.value_for('rocket.fuel.amount')).to be == '0.0'
        end
      end
    end
  end
end
