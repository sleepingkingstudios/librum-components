# frozen_string_literal: true

require 'librum/components/literal'
require 'librum/components/rspec/matchers/match_snapshot_matcher'
require 'librum/components/rspec/render_component'

RSpec.describe Librum::Components::RSpec::Matchers::MatchSnapshotMatcher do
  include Librum::Components::RSpec::RenderComponent

  subject(:matcher) { described_class.new(expected) }

  let(:expected) do
    <<~HTML
      <span>
        <i class="icon icon-radiation"></i>

        Reactor temperature critical
      </span>
    HTML
  end

  describe '.new' do
    it { expect(described_class).to be_constructible.with(1).argument }
  end

  describe '#description' do
    let(:expected) { 'match the snapshot' }

    include_examples 'should define reader', :description, -> { expected }
  end

  describe '#does_not_match?' do
    shared_context 'with a bare component' do
      let(:actual) do
        Librum::Components::Literal.new(super())
      end
      let(:failure_message) do
        'expected the component not to match the snapshot'
      end
    end

    shared_context 'with a rendered component' do
      let(:actual) do
        component = Librum::Components::Literal.new(super())

        render_component(component)
      end
      let(:failure_message) do
        'expected the string not to match the snapshot'
      end
    end

    shared_context 'with a rendered document' do
      let(:actual) do
        component = Librum::Components::Literal.new(super())

        render_document(component)
      end
      let(:failure_message) do
        'expected the document not to match the snapshot'
      end
    end

    shared_examples 'should set the failure message' do
      it 'should set the failure message' do
        matcher.does_not_match?(actual)

        expect(matcher.failure_message_when_negated).to be == failure_message
      end
    end

    let(:failure_message) do
      'expected the string not to match the snapshot'
    end

    it { expect(matcher).to respond_to(:does_not_match?).with(1).argument }

    describe 'with nil' do
      let(:actual) { nil }

      it { expect(matcher.does_not_match?(actual)).to be true }
    end

    describe 'with an Object' do
      let(:actual) { Object.new.freeze }

      it { expect(matcher.does_not_match?(actual)).to be true }
    end

    # rubocop:disable RSpec/RepeatedExampleGroupBody
    describe 'with an empty string' do
      let(:actual) { '' }

      it { expect(matcher.does_not_match?(actual)).to be true }

      wrap_context 'with a bare component' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end
    end

    describe 'with a non-matching string' do
      let(:actual) do
        <<~HTML
          <h1>Greetings, Starfighter</h1>

          <p>
            You have been recruited by the Star League to defend the frontier
            against Xur and the Ko-Dan Armada!
          </p>
        HTML
      end

      it { expect(matcher.does_not_match?(actual)).to be true }

      wrap_context 'with a bare component' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end
    end

    describe 'with a partially-matching string' do
      let(:actual) do
        <<~HTML
          <span>
            <i class="icon icon-tea"></i>

            Tea temperature pleasant
          </span>
        HTML
      end

      it { expect(matcher.does_not_match?(actual)).to be true }

      wrap_context 'with a bare component' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.does_not_match?(actual)).to be true }
      end
    end

    describe 'with a matching string' do
      let(:actual) { expected }

      it { expect(matcher.does_not_match?(actual)).to be false }

      include_examples 'should set the failure message'

      wrap_context 'with a bare component' do
        it { expect(matcher.does_not_match?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.does_not_match?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.does_not_match?(actual)).to be false }

        include_examples 'should set the failure message'
      end
    end
    # rubocop:enable RSpec/RepeatedExampleGroupBody
  end

  describe '#failure_message' do
    include_examples 'should define reader', :failure_message
  end

  describe '#failure_message_when_negated' do
    include_examples 'should define reader', :failure_message_when_negated
  end

  describe '#matches?' do
    shared_context 'with a bare component' do
      let(:actual) do
        Librum::Components::Literal.new(super())
      end
      let(:diffable) { pretty_render(actual) }
      let(:failure_message) do
        "expected the component to match the snapshot:\n\n#{generate_diff}"
      end
    end

    shared_context 'with a rendered component' do
      let(:actual) do
        component = Librum::Components::Literal.new(super())

        render_component(component)
      end
      let(:failure_message) do
        "expected the string to match the snapshot:\n\n#{generate_diff}"
      end
    end

    shared_context 'with a rendered document' do
      let(:actual) do
        component = Librum::Components::Literal.new(super())

        render_document(component)
      end
      let(:diffable) do
        Librum::Components::RSpec::Utils::PrettyRender.new.call(actual)
      end
      let(:failure_message) do
        "expected the document to match the snapshot:\n\n#{generate_diff}"
      end
    end

    shared_examples 'should set the failure message' do
      it 'should set the failure message' do
        matcher.matches?(actual)

        expect(matcher.failure_message).to be == failure_message
      end
    end

    def generate_diff
      Diffy::Diff.new(expected, diffable).to_s(:color)
    end

    let(:diffable) { actual.to_s }
    let(:failure_message) do
      "expected the string to match the snapshot:\n\n#{generate_diff}"
    end

    it { expect(matcher).to respond_to(:matches?).with(1).argument }

    describe 'with nil' do
      let(:actual) { nil }
      let(:failure_message) do
        "expected the object to match the snapshot:\n\n#{generate_diff}"
      end

      it { expect(matcher.matches?(actual)).to be false }

      include_examples 'should set the failure message'
    end

    describe 'with an Object' do
      let(:actual) { Object.new.freeze }
      let(:failure_message) do
        "expected the object to match the snapshot:\n\n#{generate_diff}"
      end

      it { expect(matcher.matches?(actual)).to be false }

      include_examples 'should set the failure message'
    end

    # rubocop:disable RSpec/RepeatedExampleGroupBody
    describe 'with an empty string' do
      let(:actual)   { '' }
      let(:diffable) { pretty_render(actual) }

      it { expect(matcher.matches?(actual)).to be false }

      include_examples 'should set the failure message'

      wrap_context 'with a bare component' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end
    end

    describe 'with a non-matching string' do
      let(:actual) do
        <<~HTML
          <h1>Greetings, Starfighter</h1>

          <p>
            You have been recruited by the Star League to defend the frontier
            against Xur and the Ko-Dan Armada!
          </p>
        HTML
      end

      it { expect(matcher.matches?(actual)).to be false }

      include_examples 'should set the failure message'

      wrap_context 'with a bare component' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end
    end

    describe 'with a partially-matching string' do
      let(:actual) do
        <<~HTML
          <span>
            <i class="icon icon-tea"></i>

            Tea temperature pleasant
          </span>
        HTML
      end

      it { expect(matcher.matches?(actual)).to be false }

      include_examples 'should set the failure message'

      wrap_context 'with a bare component' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.matches?(actual)).to be false }

        include_examples 'should set the failure message'
      end
    end

    describe 'with a matching string' do
      let(:actual) { expected }

      it { expect(matcher.matches?(actual)).to be true }

      wrap_context 'with a bare component' do
        it { expect(matcher.matches?(actual)).to be true }
      end

      wrap_context 'with a rendered component' do
        it { expect(matcher.matches?(actual)).to be true }
      end

      wrap_context 'with a rendered document' do
        it { expect(matcher.matches?(actual)).to be true }
      end
    end
    # rubocop:enable RSpec/RepeatedExampleGroupBody
  end
end
