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

    # @overload checkbox(name, **options)
    #   Builds a checkbox component and maps the result value and errors.
    #
    #   @param name [String] the name of the checkbox.
    #   @param options [Hash] additional options to pass to the checkbox.
    #
    #   @return [Librum::Components::Base, ActiveSupport::SafeBuffer] the
    #     generated component, or a fallback if no component is defined.
    def checkbox(name, **)
      input(name, type: 'checkbox', **)
    end

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

    # Builds an input component and maps the result value and errors.
    #
    # @param name [String] the name of the input.
    # @param type [String] the type of the input. Defaults to "text".
    # @param options [Hash] additional options to pass to the input.
    #
    # @return [Librum::Components::Base, ActiveSupport::SafeBuffer] the
    #   generated component, or a fallback if no component is defined.
    def input(name, type: 'text', **options)
      tools.assertions.validate_name(name, as: 'name')

      value   = value_for(name)
      errors  = errors_for(name)
      options = options_for(type:, value:, errors:, **options)

      build_input(name:, type:, options:)
    end

    # @overload select(name, values:, **options)
    #   Builds a select component and maps the result value and errors.
    #
    #   @param name [String] the name of the input.
    #   @param values [Array<Hash>] the options for the select input.
    #   @param options [Hash] additional options to pass to the input.
    #
    #   @return [Librum::Components::Base, ActiveSupport::SafeBuffer] the
    #     generated component, or a fallback if no component is defined.
    def select(name, values:, **)
      input(name, type: 'select', values:, **)
    end

    # @overload text_area(name, **options)
    #   Builds a textarea component and maps the result value and errors.
    #
    #   @param name [String] the name of the input.
    #   @param options [Hash] additional options to pass to the input.
    #
    #   @return [Librum::Components::Base, ActiveSupport::SafeBuffer] the
    #     generated component, or a fallback if no component is defined.
    def text_area(name, **)
      input(name, type: 'textarea', **)
    end
    alias textarea text_area

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

    def build_input(name:, options:, type:)
      return field_component.new(name:, type:, **options) if field_component

      return missing_component.new(name: 'Forms::Field') if missing_component

      content_tag('div', style: 'color: #f00;') do
        'Missing Component Forms::Field'
      end
    end

    def field_component
      return @field_component if @field_component

      return unless components.const_defined?('Forms::Field')

      @field_component = components.const_get('Forms::Field')
    end

    def missing_component
      return @missing_component if @missing_component

      return unless components.const_defined?('MissingComponent')

      @missing_component = components.const_get('MissingComponent')
    end

    def options_for(errors:, type:, value:, **options)
      if value && type == 'checkbox'
        options[:checked] = true
      elsif value
        options[:value] = value
      end

      return options if errors.blank?

      options_for_errors(errors:, type:, **options)
    end

    def options_for_errors(errors:, **options)
      options.merge(message: errors.join(', '))
    end

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
