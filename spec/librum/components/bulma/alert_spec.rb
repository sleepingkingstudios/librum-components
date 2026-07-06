# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Alert,
  framework: :bulma,
  type:      :component \
do
  let(:message)           { 'Something went wrong' }
  let(:type)              { 'error' }
  let(:component_options) { { message:, type: } }

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :icon,
    default: -> { component.theme.error_icon }

  describe '#call' do
    let(:dismissable_attributes) do
      ' x-on:close="open = false" x-data="{ open: true }" x-show="open"'
    end
    let(:dismissable_button) do
      <<~HTML.strip
        <button class="is-pulled-right" x-on:click="$dispatch('close')">
          <span class="icon">
            <i class="fa-solid fa-circle-xmark"></i>
          </span>
        </button>
      HTML
    end
    let(:snapshot) do
      <<~HTML
        <div class="alert has-text-#{component.theme.error_color} is-#{type} mb-1"#{dismissable_attributes}>
          <span class="icon has-text-weight-bold">
            <i class="fa-solid fa-#{component.theme.error_icon}"></i>
          </span>

          Something went wrong

        #{indent(dismissable_button, 2)}
        </div>
      HTML
    end

    define_method :indent do |str, count|
      offset = ' ' * count

      str
        .lines
        .map { |line| line.start_with?("\n") ? line : "#{offset}#{line}" }
        .join
    end

    include_deferred 'with configuration',
      default_icon_family: 'font-awesome',
      icon_families:       %i[font-awesome]

    include_deferred 'with theme'

    it { expect(rendered).to match_snapshot }

    describe 'with dismissable: false' do
      let(:component_options) { super().merge(dismissable: false) }
      let(:snapshot) do
        <<~HTML
          <div class="alert has-text-#{component.theme.error_color} is-#{type} mb-1">
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-#{component.theme.error_icon}"></i>
            </span>

            Something went wrong
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with icon: value' do
      let(:component_options) { super().merge(icon: 'radiation') }
      let(:snapshot) do
        <<~HTML
          <div class="alert has-text-danger is-#{type} mb-1"#{dismissable_attributes}>
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-radiation"></i>
            </span>

            Something went wrong

          #{indent(dismissable_button, 2)}
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with type: "danger"' do
      let(:type) { 'danger' }
      let(:snapshot) do
        <<~HTML
          <div class="alert has-text-#{component.theme.danger_color} is-#{type} mb-1"#{dismissable_attributes}>
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-#{component.theme.danger_icon}"></i>
            </span>

            Something went wrong

          #{indent(dismissable_button, 2)}
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with type: "info"' do
      let(:type) { 'info' }
      let(:snapshot) do
        <<~HTML
          <div class="alert has-text-#{component.theme.info_color} is-#{type} mb-1"#{dismissable_attributes}>
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-#{component.theme.info_icon}"></i>
            </span>

            Something went wrong

          #{indent(dismissable_button, 2)}
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with type: "success"' do
      let(:type) { 'success' }
      let(:snapshot) do
        <<~HTML
          <div class="alert has-text-#{component.theme.success_color} is-#{type} mb-1"#{dismissable_attributes}>
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-#{component.theme.success_icon}"></i>
            </span>

            Something went wrong

          #{indent(dismissable_button, 2)}
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with type: "warning"' do
      let(:type) { 'warning' }
      let(:snapshot) do
        <<~HTML
          <div class="alert has-text-#{component.theme.warning_color} is-#{type} mb-1"#{dismissable_attributes}>
            <span class="icon has-text-weight-bold">
              <i class="fa-solid fa-#{component.theme.warning_icon}"></i>
            </span>

            Something went wrong

          #{indent(dismissable_button, 2)}
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end
  end
end
