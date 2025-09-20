# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Builds and renders a form using form field components.
  class Form < Librum::Components::Base # rubocop:disable Metrics/ClassLength
    include ActionView::Helpers::SanitizeHelper

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
      @fields = []

      super(**)
    end

    # @return [Cuprum::Result] the result returned by the controller action.
    attr_reader :result

    # Generates the form contents, replacing any value in #content.
    #
    # @yield the block used to generate the contents.
    # @yieldparam builder [Librum::Components::Form::Builder] the builder used
    #   to generate the contents. Provides wrapper methods for defining form
    #   fields, including #input, #checkbox, #select, and #text_area.
    #
    # @return [self] the form.
    def build(&block)
      builder = self.class::Builder.new(fields:, form: self)

      block.call(builder)

      self
    end

    # Generates the form.
    #
    # @return [ActiveSupport::SafeBuffer] the rendered form.
    def call
      with_content(render_fields) unless fields.empty?

      if action
        form_with(url: action, method: http_method) { content }
      else
        content_tag('form') { content }
      end
    end

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

    attr_reader :fields

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

    def render_field(field)
      return render(field) if field.is_a?(ViewComponent::Base)

      return field if field.is_a?(ActiveSupport::SafeBuffer)

      # :nocov:
      return sanitize(field, attributes: [], tags: []) if field.is_a?(String)

      raise ArgumentError, 'field is not a String or a component'
      # :nocov:
    end

    def render_fields
      fields.reduce(ActiveSupport::SafeBuffer.new) do |buffer, field|
        buffer << render_field(field) << "\n"
      end
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
