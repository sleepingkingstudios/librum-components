# frozen_string_literal: true

require 'librum/components/bulma/options'

module Librum::Components::Bulma::Options
  # Options for passing Bulma typography helpers to a component.
  module Typography
    include Librum::Components::Options

    # The valid option values for the :alignment option.
    ALIGNMENTS = Set.new(%w[centered justified left right]).freeze

    # The valid option values for the :font_family option.
    FONT_FAMILIES =
      Set.new(%w[code monospace primary sans-serif secondary]).freeze

    # The valid option values for the :size option.
    SIZES = Set.new([*(1..7), *(1..7).map(&:to_s)]).freeze

    # The valid option values for the :transform option.
    TRANSFORMS = Set.new(%w[capitalized lowercase uppercase]).freeze

    # The valid option values for the :weight option.
    WEIGHTS = Set.new(%w[light normal medium semibold bold]).freeze

    option :alignment,   validate: { inclusion: ALIGNMENTS }
    option :font_family, validate: { inclusion: FONT_FAMILIES }
    option :italic,      boolean:  true
    option :size,        validate: { inclusion: SIZES }
    option :transform,   validate: { inclusion: TRANSFORMS }
    option :underlined,  boolean:  true
    option :weight,      validate: { inclusion: WEIGHTS }

    private

    def typography_class # rubocop:disable Metrics/CyclomaticComplexity
      bulma_class_names(
        alignment   ? "has-text-#{alignment}"     : nil,
        weight      ? "has-text-weight-#{weight}" : nil,
        size        ? "is-size-#{size}"           : nil,
        transform   ? "is-#{transform}"           : nil,
        font_family ? "is-family-#{font_family}"  : nil,
        italic?     ? 'is-italic'                 : nil,
        underlined? ? 'is-underlined'             : nil
      )
    end

    def typography_options # rubocop:disable Metrics/MethodLength
      options
        .slice(
          :alignment,
          :font_family,
          :italic,
          :size,
          :transform,
          :underlined,
          :weight
        )
        .compact
    end
  end
end
