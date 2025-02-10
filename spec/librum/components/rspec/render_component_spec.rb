# frozen_string_literal: true

require 'librum/components/rspec/render_component'

RSpec.describe Librum::Components::RSpec::RenderComponent do
  subject(:example) { Object.new.extend(described_class) }

  example_class 'Spec::Component', ViewComponent::Base do |klass|
    klass.define_method(:initialize) { |contents| @contents = contents }

    klass.attr_reader :contents

    klass.define_method(:call) do
      Loofah
        .html5_fragment(contents)
        .scrub!(:strip)
        .to_s
        .html_safe # rubocop:disable Rails/OutputSafety
    end
  end

  describe '#render_component' do
    it { expect(example).to respond_to(:render_component).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        'expected an instance of ViewComponent::Base, got nil'
      end

      it 'should raise an exception' do
        expect { example.render_component(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:component) { Object.new.freeze }
      let(:error_message) do
        "expected an instance of ViewComponent::Base, got #{component.inspect}"
      end

      it 'should raise an exception' do
        expect { example.render_component(component) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a component' do
      let(:contents) do
        <<~HTML
          <ul>
            <li>Ichi</li>
                <li>Ni</li>


            <li>San</li>
          </ul>
        HTML
      end
      let(:component) { Spec::Component.new(contents) }

      it { expect(example.render_component(component)).to be == contents }
    end
  end

  describe '#render_document' do
    it { expect(example).to respond_to(:render_document).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        'expected an instance of ViewComponent::Base, got nil'
      end

      it 'should raise an exception' do
        expect { example.render_document(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:component) { Object.new.freeze }
      let(:error_message) do
        "expected an instance of ViewComponent::Base, got #{component.inspect}"
      end

      it 'should raise an exception' do
        expect { example.render_document(component) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a component' do
      let(:contents) do
        <<~HTML
          <ul>
            <li>Ichi</li>
                <li>Ni</li>


            <li>San</li>
          </ul>
        HTML
      end
      let(:component) { Spec::Component.new(contents) }

      it 'should return a Nokogiri document fragment' do
        expect(example.render_document(component))
          .to be_a Nokogiri::HTML::DocumentFragment
      end

      it { expect(example.render_document(component).to_s).to be == contents }
    end
  end
end
