# frozen_string_literal: true

require 'librum/components/rspec'

module Librum::Components::RSpec
  # Namespace for shared RSpec matchers.
  module Matchers
    UNDEFINED = Object.new.freeze
    private_constant :UNDEFINED

    autoload :MatchSnapshotMatcher,
      'librum/components/rspec/matchers/match_snapshot_matcher'

    # @overload match_snapshot
    #   Returns a snapshot matcher against the value of the #snapshot method.
    #
    #   @return [Librum::Components::RSpec::Matchers::MatchSnapshotMatcher] the
    #     snapshot matcher.
    #
    # @overload match_snapshot(expected)
    #   Returns a snapshot matcher with the given expected value.
    #
    #   @param expected [String] the expected string.
    #
    #   @return [Librum::Components::RSpec::Matchers::MatchSnapshotMatcher] the
    #     snapshot matcher.
    def match_snapshot(expected = UNDEFINED)
      expected = send(:snapshot) if expected == UNDEFINED

      Librum::Components::RSpec::Matchers::MatchSnapshotMatcher.new(expected)
    end
  end
end
