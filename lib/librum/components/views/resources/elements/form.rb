# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Views::Resources::Elements
  # Generic component for rendering a form for a resource entity.
  class Form < Librum::Components::View
    allow_extra_options

    option :action,      validate: String
    option :http_method, validate: true
    option :routes,      required: true, validate: Cuprum::Rails::Routes

    # @overload initialize(request:, resource: nil, result:, **options)
    #   @param result [Cuprum::Result] the result returned by the controller
    #     action.
    #   @param resource [Cuprum::Rails::Resource] the resource for the
    #     controller.
    #   @param options [Hash] additional options for the view.
    def initialize(resource:, result:, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      render_form
    end

    # @return [String] the path to navigate to when cancelling the form.
    def cancel_url
      case # rubocop:disable Style/EmptyCaseCondition
      when create_form? then routes.index_path
      when update_form? then routes.show_path
      else
        raise "unhandled action name #{action_name.inspect}"
      end
    end

    # @return [true, false] if true, configures the form to perform a remote
    #   request. i.e. an XHR or Turbo request.
    def remote?
      if resource.respond_to?(:remote_forms)
        resource.remote_forms.then { |value| return value unless value.nil? }
      end

      configuration.remote_forms
    end

    # @return [String] the path submitted to by the form.
    def form_action
      return action if action

      case # rubocop:disable Style/EmptyCaseCondition
      when create_form? then routes.create_path
      when update_form? then routes.update_path
      else
        raise "unhandled action name #{action_name.inspect}"
      end
    end

    # @return [Symbol] the HTTP method used to submit the form.
    def form_http_method
      return http_method if http_method

      case # rubocop:disable Style/EmptyCaseCondition
      when create_form? then :post
      when update_form? then :patch
      else
        raise "unhandled action name #{action_name.inspect}"
      end
    end

    # @return [String] the label for the form submit button.
    def submit_text
      case # rubocop:disable Style/EmptyCaseCondition
      when create_form? then "Create #{resource.singular_name.titleize}"
      when update_form? then "Update #{resource.singular_name.titleize}"
      else
        raise "unhandled action name #{action_name.inspect}"
      end
    end

    private

    def create_form?
      action_name == 'create' || action_name == 'new' # rubocop:disable Style/MultipleComparison
    end

    def evaluate_fields(fields)
      ->(form) { instance_exec(form, &fields) }
    end

    def fields
      if self.class.const_defined?(:FIELDS)
        return evaluate_fields(self.class.const_get(:FIELDS))
      end

      message =
        "#{self.class.name} is an abstract class - implement a subclass and " \
        'define a #fields method'

      raise message
    end

    def form_options
      {
        action:      form_action,
        fields:,
        http_method: form_http_method,
        remote:      remote?,
        result:
      }
    end

    def render_form
      render build_component('Form', **form_options)
    end

    def update_form?
      action_name == 'edit' || action_name == 'update' # rubocop:disable Style/MultipleComparison
    end
  end
end
