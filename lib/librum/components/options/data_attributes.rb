# frozen_string_literal: true

module Librum::Components::Options
  # Option for passing a data parameter to a component.
  module DataAttributes
    include Librum::Components::Options
    include Librum::Components::Sanitize

    class << self
      # @overload flatten_hash(hsh)
      #   Reduces the given hash to a flat hash with String keys and values.
      #
      #   @param hsh [Hash{String, Symbol => Object}] the hash to flatten.
      #
      #   @return [Hash{String => String}] the flattened hash.
      def flatten_hash(hsh, buf: {}, prefix: 'data-')
        hsh&.each do |key, value|
          next if value.nil? || (value.respond_to?(:empty?) && value.empty?)

          key = normalize_key(key, prefix:)

          if value.is_a?(Hash)
            flatten_hash(value, buf:, prefix: "#{key}-")
          else
            buf[key] = value.to_s
          end
        end

        buf
      end

      private

      def normalize_key(key, prefix:)
        key = key.to_s.tr('_', '-')

        if (prefix == '' || prefix == 'data-') && key.start_with?('data-') # rubocop:disable Style/MultipleComparison
          key = key[5..]
        end

        "#{prefix}#{key}"
      end
    end

    option :data, validate: Hash

    # @return [Hash{String => Object}] the flattened data attributes.
    def data
      return @data if @data

      return if options[:data].nil?

      @data ||= DataAttributes.flatten_hash(options[:data], prefix: '')
    end

    # Generates HTML data attributes from a data hash.
    #
    # @return [String, nil] the data attributes, or nil if the data is empty.
    def render_data
      return nil if data.blank?

      DataAttributes
        .flatten_hash(data, prefix: 'data-')
        .map { |key, value| sanitize_data_attribute(key, value) }
        .join
        .html_safe # rubocop:disable Rails/OutputSafety
    end

    private

    def sanitize_data_attribute(key, value)
      key   = strip_tags(key)
      value = strip_tags(value)

      # Enable unescaped pattern for Stimulus controller actions.
      value = value.gsub('-&gt;', '->') if key == 'data-action'

      %( #{key}="#{value}")
    end
  end
end
