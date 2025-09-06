# frozen_string_literal: true

require 'librum/components/errors'

module Librum::Components::Errors
  # Exception raised when defining options on an abstract component.
  class AbstractComponentError < StandardError; end
end
