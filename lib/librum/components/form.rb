# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Builds and renders a form using form field components.
  class Form < Librum::Components::Base
    BRACKET_PATTERN = /\]?\[/
    private_constant :BRACKET_PATTERN

    option :action,      validate: String
    option :http_method, validate: true

    # @overload initialize(result:, **options)
    #   @param result [Cuprum::Result] the result returned by the controller
    #     action.
    #   @param options [Hash] additional options for the form.
    def initialize(result:, **)
      @result = result

      super(**)
    end

    # @return [Cuprum::Result] the result returned by the controller action.
    attr_reader :result

    # Retrieves the errors from the result corresponding to the given path.
    #
    # @param path [String] the relative path of the errors.
    #
    # @return [Array<String>] the matching errors.
    def errors_for(path)
      tools.assertions.validate_name(path, as: 'path')

      return [] unless result_errors

      path     = split_path(path)
      matching = result_errors.dig(*path)

      matching.map { |err| err[:message] } # rubocop:disable Rails/Pluck
    end

    # Retrieves the value from the result corresponding to the given path.
    #
    # @param path [String] the relative path of the value.
    #
    # @return [Object, nil] the matching value, or nil if there is no matching
    #   value.
    def value_for(path)
      tools.assertions.validate_name(path, as: 'path')

      path = split_path(path)

      path.reduce(result.value) do |obj, key|
        next obj[key] if obj.is_a?(Hash)

        next obj.public_send(key) if obj.respond_to?(key)

        break
      end
    end

    private

    def result_errors
      return @result_errors if @result_errors

      return nil unless result.error.respond_to?(:errors)

      @result_errors = result.error.errors.with_messages
    end

    def split_path(path)
      return path[...-1].split(BRACKET_PATTERN) if path.end_with?(']')

      path.to_s.split('.')
    end
  end
end
