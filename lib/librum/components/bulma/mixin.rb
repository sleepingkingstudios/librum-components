# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Helper methods for building a Bulma component.
  module Mixin
    # @overload bulma_class_names(*args)
    #   Combines the given class names and applies the configured bulma prefix.
    #
    #   @param args [Array] the input arguments to combine.
    #
    #   @return [String] the combined output string.
    #
    #   @see Librum::Components::Base#class_names.
    def bulma_class_names(*)
      class_names(*, prefix: configuration.bulma_prefix)
    end

    private

    def default_components
      Librum::Components::Bulma
    end

    def default_configuration
      Librum::Components::Bulma::Configuration.default
    end
  end
end
