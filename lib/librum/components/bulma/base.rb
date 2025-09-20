# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Abstract base component for components using the Bulma CSS Framework.
  #
  # @see https://bulma.io/
  class Base < Librum::Components::Base
    include Librum::Components::Bulma::Mixin

    class << self
      # @return [true, false] true if the component class is an abstract class;
      #   otherwise returns false.
      def abstract?
        self == Librum::Components::Bulma::Base
      end
    end
  end
end
