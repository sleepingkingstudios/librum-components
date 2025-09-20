# frozen_string_literal: true

require 'librum/components'

module Librum::Components::RSpec::Utils
  # Utility class for rendering HTML documents with a consistent format.
  class PrettyRender # rubocop:disable Metrics/ClassLength
    LINE_LEADING_WHITESPACE_PATTERN = /\A( *)[^\s]/
    private_constant :LINE_LEADING_WHITESPACE_PATTERN

    TRAILING_WHITESPACE_PATTERN = /\n( +)\z/
    private_constant :TRAILING_WHITESPACE_PATTERN

    # @param document [Nokogiri::XML::Node] the document or tag to render.
    #
    # @return [String] the rendered HTML.
    def call(document)
      render_children(document)
    end

    private

    def authenticity_token?(tag)
      return false unless tag.name == 'input'

      tag.attributes['name']&.value == 'authenticity_token'
    end

    def child_tags(tag)
      tag
        .children
        .reject { |child| child.text? && child.to_s =~ /\A\s*\z/ }
    end

    def closing_tag(tag)
      "</#{tag.name}>"
    end

    def format_attributes(tag)
      tag
        .attributes
        .each_value
        .map { |attribute| %(#{attribute.name}="#{attribute.value}") }
        .join(' ')
    end

    def has_children?(tag) # rubocop:disable Naming/PredicatePrefix
      tag.children.any?(&:element?)
    end

    def has_text?(tag) # rubocop:disable Naming/PredicatePrefix
      tag.children.any?(&:text?)
    end

    def indent(str)
      str
        .lines
        .map { |line| line.start_with?("\n") ? line : "  #{line}" }
        .join
    end

    def join_text(tag)
      tag
        .children
        .select(&:text?)
        .map(&:to_s)
        .join
    end

    def minimum_indent(text)
      min = text.length
      rxp = LINE_LEADING_WHITESPACE_PATTERN

      text.each_line do |line|
        indent = line.match(rxp)&.[](1)&.size

        next unless indent

        min = indent if indent < min
      end

      min == text.length ? 0 : min
    end

    def opening_tag(tag)
      return "<#{tag.name}>" if tag.attributes.empty?

      "<#{tag.name} #{format_attributes(tag)}>"
    end

    def realign_text(text) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      # First, try to align the text with the close tag on a following line.
      match  = text.match(TRAILING_WHITESPACE_PATTERN)
      offset = match&.[](1)&.size

      if offset
        text =
          text
          .each_line
          .map { |line| line.sub(/\A#{' ' * offset}/, '') }
          .join

        return text
      end

      # Next, we try and identify the smallest indent for a line that contains
      # non-whitespace characters.
      offset = match ? match[1].size : minimum_indent(text)

      # The smallest indentation after the realignment should be two spaces,
      # with relative indentation unchanged.
      text.each_line.map { |line| line.sub(/\A#{' ' * offset}/, '  ') }.join
    end

    def render_authenticity_token
      %(<input type="hidden" name="authenticity_token" value="[token]" ) +
        'autocomplete="off">'
    end

    def render_children(tag)
      buffer = +''

      child_tags(tag).each.with_index.map do |child, index|
        buffer << "\n\n" unless index.zero?

        buffer << render_tag(child)
      end

      buffer << "\n"
    end

    def render_tag(tag)
      return render_tag_with_children(tag) if has_children?(tag)
      return render_tag_with_text(tag)     if has_text?(tag)
      return render_authenticity_token     if authenticity_token?(tag)

      tag.to_s.strip
    end

    def render_tag_with_children(tag)
      buffer = +''
      buffer << opening_tag(tag) << "\n"
      buffer << indent(render_children(tag))
      buffer << closing_tag(tag)
    end

    def render_tag_with_text(tag)
      buffer = +''
      buffer << opening_tag(tag)
      buffer << render_text(tag)
      buffer << closing_tag(tag)
    end

    def render_text(tag)
      text     = join_text(tag)
      stripped = text.strip

      return '' if stripped.empty?

      return "\n  #{stripped}\n" unless stripped.include?("\n")

      # Aligns the text content with the closing tag.
      text = realign_text(text)

      # Remove extra whitespace from empty lines.
      text = text.gsub(/^\n\s+$/, "\n")

      # Restore leading and trailing newlines.
      text.sub(/\A\n*/, "\n").sub(/\n*\z/, "\n")
    end
  end
end
