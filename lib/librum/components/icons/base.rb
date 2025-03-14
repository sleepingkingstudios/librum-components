# frozen_string_literal: true

require 'librum/components/icons'

module Librum::Components::Icons
  # Abstract base class for icon components.
  class Base < Librum::Components::Base
    class << self
      # @return [true, false] true if the component class is an abstract class;
      #   otherwise returns false.
      def abstract?
        self == Librum::Components::Icons::Base
      end
    end
  end
end
