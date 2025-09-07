# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::RSpec::RenderComponent do
  subject(:example) { Object.new.extend(described_class) }

  describe '#pretty_render' do
    let(:contents) do
      <<~HTML
        <ul>
          <li>Ichi</li>
              <li>Ni</li>


          <li>San</li>
        </ul>
      HTML
    end
    let(:expected) do
      <<~HTML
        <ul>
          <li>Ichi</li>

          <li>Ni</li>

          <li>San</li>
        </ul>
      HTML
    end

    it { expect(example).to respond_to(:pretty_render).with(1).argument }

    describe 'with nil' do
      let(:error_message) do
        'expected an instance of ViewComponent::Base, got nil'
      end

      it 'should raise an exception' do
        expect { example.pretty_render(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:component) { Object.new.freeze }
      let(:error_message) do
        "expected an instance of ViewComponent::Base, got #{component.inspect}"
      end

      it 'should raise an exception' do
        expect { example.pretty_render(component) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a String' do
      it { expect(example.pretty_render(contents)).to be == expected }
    end

    describe 'with a component' do
      let(:component) { Librum::Components::Literal.new(contents) }

      it { expect(example.pretty_render(component)).to be == expected }
    end

    describe 'with a document' do
      let(:document) { Nokogiri::HTML5.fragment(contents) }

      it { expect(example.pretty_render(document)).to be == expected }
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
      let(:component) { Librum::Components::Literal.new(contents) }

      it { expect(example.render_component(component)).to be == contents }

      describe 'with a block' do
        let(:component) { Spec::ComponentWithBlock.new }
        let(:expected) do
          <<~HTML.strip
            <div><ul>
              <li>Ichi</li>
                  <li>Ni</li>


              <li>San</li>
            </ul>
            </div>
          HTML
        end

        example_class 'Spec::ComponentWithBlock', Librum::Components::Base \
        do |klass|
          klass.define_method :call do
            content_tag(:div) { content }
          end
        end

        it 'should render the component' do
          expect(example.render_component(component) { contents.html_safe }) # rubocop:disable Rails/OutputSafety
            .to be == expected
        end
      end
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
      let(:component) { Librum::Components::Literal.new(contents) }

      it 'should return a Nokogiri document fragment' do
        expect(example.render_document(component))
          .to be_a Nokogiri::HTML::DocumentFragment
      end

      it { expect(example.render_document(component).to_s).to be == contents }
    end
  end
end
