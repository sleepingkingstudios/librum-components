# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Abstract component for a view rendering a Result for a controller action.
  class View < Librum::Components::Base
    extend Forwardable

    class << self
      # @return [true, false] true if the component class is an abstract class;
      #   otherwise returns false.
      def abstract?
        self == Librum::Components::View
      end
    end

    # @overload initialize(result:, resource: nil, **options)
    #   @param result [Cuprum::Result] the result returned by the controller
    #     action.
    #   @param request [Cuprum::Rails::Request] the request handled by the
    #     controller.
    #   @param resource [Cuprum::Rails::Resource] the resource for the
    #     controller.
    #   @param options [Hash] additional options for the view.
    def initialize(result:, request: nil, resource: nil, **)
      @request  = request
      @result   = result
      @resource = resource

      super(**)
    end

    # @return [Cuprum::Rails::Request] the request handled by the controller.
    attr_reader :request

    # @return [Cuprum::Rails::Resource] the resource for the controller.
    attr_reader :resource

    # @return [Cuprum::Result] the result returned by the controller action.
    attr_reader :result

    # @!method error
    #   @return [Cuprum::Error] the error from the result, if any.

    # @!method status
    #   @return [Symbol] the result status.

    # @!method value
    #   @return [Object] the value from the result, if any.
    def_delegators :@result,
      :error,
      :status,
      :value

    # @return [String] the name of the called action.
    def action_name
      metadata.fetch('action_name') { super }
    end

    # @return [String] the name of the called controller.
    def controller_name
      metadata.fetch('controller_name') { super }
    end

    # @return [true, false] true if the called controller action was a member
    #   action, otherwise false.
    def member_action?
      metadata.fetch('member_action', false)
    end

    # @return [Hash] the result metadata, if any.
    def metadata
      return {} unless result.respond_to?(:metadata)

      result.metadata
    end
  end
end
