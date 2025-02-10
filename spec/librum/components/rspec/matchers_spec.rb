# frozen_string_literal: true

require 'librum/components/rspec/matchers'

RSpec.describe Librum::Components::RSpec::Matchers do
  include Librum::Components::RSpec::Matchers # rubocop:disable RSpec/DescribedClass

  let(:example_group) { self }

  describe '#match_snapshot' do
    let(:matcher_class) do
      Librum::Components::RSpec::Matchers::MatchSnapshotMatcher
    end

    it 'should define the method' do
      expect(example_group).to respond_to(:match_snapshot).with(0..1).arguments
    end

    describe 'with no arguments' do
      let(:matcher)       { example_group.match_snapshot }
      let(:error_message) { /undefined method 'snapshot'/ }

      it 'should raise an exception' do
        expect { example_group.match_snapshot }
          .to raise_error(NoMethodError, error_message)
      end

      context 'when the #snapshot method is defined' do
        let(:snapshot) { '<h1>Greetings, Programs</h1>' }

        it { expect(matcher).to be_a matcher_class }

        it { expect(matcher.expected).to be == snapshot }
      end
    end

    describe 'with an expected value' do
      let(:expected) { '<h1>Greetings, Programs</h1>' }
      let(:matcher)  { example_group.match_snapshot(expected) }

      it { expect(matcher).to be_a matcher_class }

      it { expect(matcher.expected).to be == expected }
    end
  end
end
