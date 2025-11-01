# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::SafeBuffer do
  subject(:helpers) { Object.new.extend(described_class) }

  describe '#safe_buffer' do
    it 'should define the method' do
      expect(helpers).to respond_to(:safe_buffer).with(0).arguments.and_a_block
    end

    it { expect(helpers.safe_buffer).to be_a ActiveSupport::SafeBuffer }

    it { expect(helpers.safe_buffer.size).to be 0 }

    describe 'with a block' do
      it 'should yield the buffer' do
        expect { |block| helpers.safe_buffer(&block) }
          .to yield_with_args(an_instance_of(ActiveSupport::SafeBuffer))
      end

      it 'should return a safe buffer' do
        expect(helpers.safe_buffer(&nil)).to be_a ActiveSupport::SafeBuffer
      end

      it { expect(helpers.safe_buffer(&nil).size).to be 0 }

      context 'when the block modifies the buffer' do
        let(:block) do
          lambda do |buffer|
            buffer << 'Greetings'
            buffer << ', programs!'

            :ok
          end
        end
        let(:expected) { 'Greetings, programs!' }

        it 'should return the buffer' do
          expect(helpers.safe_buffer(&block)).to be_a ActiveSupport::SafeBuffer
        end

        it 'should yield and return the buffer' do
          expect(helpers.safe_buffer(&block).to_s).to be == expected
        end
      end
    end
  end

  describe '#safe_buffer?' do
    it { expect(helpers).to respond_to(:safe_buffer?).with(1).argument }

    it { expect(helpers.safe_buffer?(nil)).to be false }

    it { expect(helpers.safe_buffer?(Object.new.freeze)).to be false }

    it { expect(helpers.safe_buffer?(String)).to be false }

    it { expect(helpers.safe_buffer?(helpers.safe_buffer)).to be true }
  end

  describe '#strip_buffer' do
    it { expect(helpers).to respond_to(:strip_buffer).with(1).argument }

    define_method :buffer do |value|
      helpers.safe_buffer << value
    end

    describe 'with nil' do
      let(:error_message) do
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            expected: String
          )
      end

      it 'should raise an exception' do
        expect { helpers.strip_buffer(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) do
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .assertions
          .error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            expected: String
          )
      end

      it 'should raise an exception' do
        expect { helpers.strip_buffer(Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:value) { '' }

      it { expect(helpers.strip_buffer(value)).to be == value }
    end

    describe 'with a non-empty String' do
      let(:value) { 'Greetings, programs!' }

      it { expect(helpers.strip_buffer(value)).to be == value }
    end

    describe 'with a String with leading whitespace' do
      let(:value)    { "\n\t Greetings, programs!" }
      let(:expected) { 'Greetings, programs!' }

      it { expect(helpers.strip_buffer(value)).to be == expected }
    end

    describe 'with a String with trailing whitespace' do
      let(:value)    { "Greetings, programs!\n   \n" }
      let(:expected) { 'Greetings, programs!' }

      it { expect(helpers.strip_buffer(value)).to be == expected }
    end

    describe 'with a String with leading and trailing whitespace' do
      let(:value)    { "\n\t Greetings, programs!\n   \n" }
      let(:expected) { 'Greetings, programs!' }

      it { expect(helpers.strip_buffer(value)).to be == expected }
    end

    describe 'with an empty safe buffer' do
      let(:value) { buffer('') }

      it { expect(helpers.strip_buffer(value)).to be == value }
    end

    describe 'with a non-empty safe buffer' do
      let(:value) { buffer('Greetings, programs!') }

      it { expect(helpers.strip_buffer(value)).to be == value }
    end

    describe 'with a safe buffer with leading whitespace' do
      let(:value)    { buffer("\n\t Greetings, programs!") }
      let(:expected) { buffer('Greetings, programs!') }

      it { expect(helpers.strip_buffer(value)).to be == expected }
    end

    describe 'with a safe buffer with trailing whitespace' do
      let(:value)    { buffer("Greetings, programs!\n   \n") }
      let(:expected) { buffer('Greetings, programs!') }

      it { expect(helpers.strip_buffer(value)).to be == expected }
    end

    describe 'with a safe buffer with leading and trailing whitespace' do
      let(:value)    { buffer("\n\t Greetings, programs!\n   \n") }
      let(:expected) { buffer('Greetings, programs!') }

      it { expect(helpers.strip_buffer(value)).to be == expected }
    end
  end
end
