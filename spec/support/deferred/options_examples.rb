# frozen_string_literal: true

require 'support/deferred'

module Spec::Support::Deferred
  module OptionsExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_examples 'should define component option' \
    do |name, boolean: false, default: nil, value: 'value'|
      name = name.to_s
      name = name.sub(/\?\z/, '') if boolean

      let(:expected_value) do
        next super() if defined?(super())

        next false if boolean && default.nil?

        next default unless default.is_a?(Proc)

        instance_exec(&default)
      end

      it { expect(described_class.options.keys).to include name }

      if boolean
        include_examples 'should define predicate', name, -> { expected_value }

        context "when the component is initialized with #{name}: false" do
          let(:component_options) { super().merge(name.intern => false) }

          it { expect(component.send(:"#{name}?")).to be false }
        end

        context "when the component is initialized with #{name}: true" do
          let(:component_options) { super().merge(name.intern => true) }

          it { expect(component.send(:"#{name}?")).to be true }
        end
      else
        include_examples 'should define reader', name, -> { expected_value }

        context "when the component is initialized with #{name}: value" do
          let(:component_options) { super().merge(name.intern => value) }

          it { expect(component.send(name)).to be == value }
        end
      end
    end
  end
end
