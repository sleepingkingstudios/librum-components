# frozen_string_literal: true

require 'diffy'

require 'librum/components/rspec/matchers'
require 'librum/components/rspec/render_component'

module Librum::Components::RSpec::Matchers
  # Matcher asserting the string or document matches the expected value.
  class MatchSnapshotMatcher
    include Librum::Components::RSpec::RenderComponent

    # @param expected [String] the expected string.
    def initialize(expected)
      @expected = expected
    end

    # @return [Object] the actual object.
    attr_reader :actual

    # @return [String] the expected string.
    attr_reader :expected

    # @return [String] the description of the matcher.
    def description
      'match the snapshot'
    end

    # @param actual [Object] the object to match.
    #
    # @return [true, false] false if the object matches the expected snapshot,
    #   otherwise true.
    def does_not_match?(actual) # rubocop:disable Naming/PredicatePrefix
      @actual   = actual
      @diffable = pretty_render(actual)

      diffable != expected
    end

    # @return [String] the message to display on failure.
    def failure_message
      "expected the #{inspect_actual} to #{description}:\n\n" + generate_diff
    end

    # @return [String] the message to display on failure for a negated matcher.
    def failure_message_when_negated
      "expected the #{inspect_actual} not to #{description}"
    end

    # @param actual [Object] the object to match.
    #
    # @return [true, false] true if the object matches the expected snapshot,
    #   otherwise false.
    def matches?(actual)
      @actual   = actual
      @diffable = pretty_render(actual)

      diffable == expected
    end

    private

    attr_reader :diffable

    def component?
      actual.is_a?(ViewComponent::Base)
    end

    def document?
      actual.is_a?(Nokogiri::XML::Node)
    end

    def generate_diff
      Diffy::Diff.new(expected, diffable).to_s(:color)
    end

    def inspect_actual
      return 'component' if component?

      return 'document' if document?

      return 'string' if string?

      'object'
    end

    def pretty_render(actual)
      super
    rescue ArgumentError
      actual.to_s
    end

    def string?
      actual.is_a?(String)
    end
  end
end
