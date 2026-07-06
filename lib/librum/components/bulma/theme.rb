# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Default Theme object for Librum::Components using the Bulma framework.
  class Theme < Librum::Components::Theme
    # Default visual options for a Bulma application.
    DEFAULTS = Librum::Components::Theme::DEFAULTS.merge(
      'danger_color'  => 'danger',
      'danger_icon'   => 'circle-xmark',
      'error_color'   => 'danger',
      'error_icon'    => 'circle-xmark',
      'info_color'    => 'info',
      'info_icon'     => 'circle-info',
      'success_color' => 'success',
      'success_icon'  => 'circle-check',
      'warning_color' => 'warning',
      'warning_icon'  => 'exclamation-triangle'
    ).freeze
  end
end
