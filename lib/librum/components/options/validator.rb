# frozen_string_literal: true

module Librum::Components::Options
  # Utility class for validating the options passed to a component.
  class Validator # rubocop:disable Metrics/ClassLength
    # @param options [Hash{String => Librum::Component::Option}] the options
    #   defined for the component.
    # @param allow_extra_options [true, false] if true, ignores unexpected
    #   options rather than raising an exception.
    def initialize(options:, allow_extra_options: false)
      @allow_extra_options = allow_extra_options
      @options             = tools.hash_tools.convert_keys_to_strings(options)
    end

    # @return [Hash{String => Librum::Component::Option}] the options defined
    #   for the component.
    attr_reader :options

    # @return [true, false] if true, ignores unexpected options rather than
    #   raising an exception.
    def allow_extra_options?
      @allow_extra_options
    end

    # Validates the options against the expected options for the component.
    #
    # @param component [Object] the cimponent to validate.
    # @param value [Hash] the options to validate.
    #
    # @return [void]
    #
    # @raises [Librum::Components::Errors::InvalidOptionsError] if the options
    #   are not valid.
    def call(component:, value:)
      @component  = component
      @aggregator = tools.assertions.aggregator_class.new
      extra_keys  = validate_extra_options(value)

      validate_options(value)

      return if aggregator.empty?

      raise Librum::Components::Errors::InvalidOptionsError,
        invalid_options_message(
          extra_keys:,
          failure_message: aggregator.failure_message
        )
    end

    private

    attr_reader \
      :aggregator,
      :component

    def accepts_name_parameter?(block)
      parameters = block.parameters

      parameters.any? do |type, name|
        name == :as && (type == :key || type == :keyreq) # rubocop:disable Style/MultipleComparison
      end
    end

    def array_validation?(validate)
      return true if validate == :array

      validate.is_a?(Hash) && validate.fetch(:array, false)
    end

    def call_validation_method(method_name:, name:, value:, validate: nil, **)
      if array_validation?(validate)
        validate_option_array(name:, value:, validate:)
      elsif aggregator.respond_to?(method_name)
        aggregator.public_send(method_name, value, as: name, **)
      else
        message = component.send(method_name, value, as: name, **)

        aggregator << message if message.present?
      end
    end

    def component_name
      component.class.name
    end

    def invalid_options_message(extra_keys:, failure_message:)
      message = "invalid options for #{component_name} - #{failure_message}"

      return message if extra_keys.empty?

      if options.empty?
        "#{message} (#{component_name} does not define any valid options)"
      else
        valid_options = options.keys.sort.map { |key| ":#{key}" }
        valid_options = tools.array_tools.humanize_list(valid_options)

        "#{failure_message} (valid options for #{component_name} are " \
          "#{valid_options})"
      end
    end

    def validate_extra_options(value)
      return [] if allow_extra_options?

      value
        .each_key
        .reject { |key| options.key?(key.to_s) }
        .each { |key| aggregator << "#{key} is not a valid option" }
    end

    def validate_option(name:, value:, required: false, validate: nil, **)
      failures = aggregator.size

      aggregator.validate_presence(value, as: name) if required

      return unless validate

      # Allow nil values for validate: Class unless the option is required.
      return if value.nil? && !required && validate.is_a?(Module)

      # Skip additional validation when there are missing required options.
      return unless aggregator.size == failures

      validate_option_value(name:, value:, validate:)
    end

    def validate_option_array(name:, value:, validate:)
      return if value.nil?

      unless value.is_a?(Array)
        aggregator << "#{name} is not an Array"

        return
      end

      validate_option_array_items(name:, value:, validate:)
    end

    def validate_option_array_items(name:, value:, validate:)
      return if validate == true

      validate = validate[:array] if validate.is_a?(Hash)

      value.each.with_index do |item, index|
        item_name = "#{name} item #{index}"

        validate_option_value(name: item_name, validate:, value: item)
      end
    end

    def validate_option_block(name:, value:, validate:)
      message =
        if accepts_name_parameter?(validate)
          validate.call(value, as: name)
        else
          validate.call(value)
        end

      aggregator << message if message.present?
    end

    def validate_option_hash(name:, value:, validate:)
      validate.each do |type, expected|
        method_name = "validate_#{type}"

        opts = expected == true ? {} : { expected: }

        call_validation_method(method_name:, name:, value:, validate:, **opts)
      end
    end

    def validate_option_instance(name:, validate:, value:)
      aggregator.validate_instance_of(value, expected: validate, as: name)
    end

    def validate_option_method(name:, validate:, value:)
      method_name = "validate_#{validate}"

      call_validation_method(method_name:, name:, value:, validate:)
    end

    def validate_option_name(name:, value:, **)
      validation_method = "validate_#{name}"

      message = component.send(validation_method, value, as: name)

      aggregator << message if message.present?
    end

    def validate_option_value(validate:, **)
      case validate
      when true           then validate_option_name(validate:, **)
      when Hash           then validate_option_hash(validate:, **)
      when Module         then validate_option_instance(validate:, **)
      when Proc           then validate_option_block(validate:, **)
      when String, Symbol then validate_option_method(validate:, **)
      end
    end

    def validate_options(value)
      options.each_value do |option|
        validate_option(**option, value: value[option.name.intern])
      end
    end

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
