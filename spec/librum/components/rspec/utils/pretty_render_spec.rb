# frozen_string_literal: true

require 'librum/components/literal'
require 'librum/components/rspec/render_component'
require 'librum/components/rspec/utils/pretty_render'

RSpec.describe Librum::Components::RSpec::Utils::PrettyRender do
  include Librum::Components::RSpec::RenderComponent

  subject(:renderer) { described_class.new }

  describe '#call' do
    let(:contents)  { '<hr>' }
    let(:component) { Librum::Components::Literal.new(contents) }
    let(:document)  { render_document(component) }
    let(:rendered)  { renderer.call(document) }
    let(:expected) do
      <<~HTML
        #{contents.strip}
      HTML
    end

    it { expect(renderer).to respond_to(:call).with(1).argument }

    it { expect(rendered).to be == expected }

    describe 'with a tag with attributes' do
      let(:contents) { '<hr class="is-fancy-hr" id="fancy-line">' }

      it { expect(rendered).to be == expected }
    end

    describe 'with a tag with children' do
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

      it { expect(rendered).to be == expected }

      describe 'with inconsistent whitespace' do
        let(:contents) do
          <<~HTML
            <ul>
              <li>Ichi</li>
                  <li>Ni</li>


              <li>San</li>
            </ul>
          HTML
        end

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a tag with children and attributes' do
      let(:contents) do
        <<~HTML
          <span data-action="launch">
            <i class="icon icon-rocket"></i>

            Launch Rocket
          </span>
        HTML
      end

      it { expect(rendered).to be == expected }
    end

    describe 'with a tag with children and text' do
      let(:contents) do
        <<~HTML
          <span>
            <i class="icon icon-rocket"></i>

            Launch Rocket
          </span>
        HTML
      end

      it { expect(rendered).to be == expected }
    end

    describe 'with a tag with multiline text' do
      let(:contents) do
        <<~HTML
          <p>
            Expected: true
              Actual: false
          </p>
        HTML
      end

      it { expect(rendered).to be == expected }

      describe 'with insufficient whitespace' do
        let(:contents) do
          <<~HTML
            <ul>
              <li>
              List Item
            </li>
            </ul>
          HTML
        end
        let(:expected) do
          <<~HTML
            <ul>
              <li>
                List Item
              </li>
            </ul>
          HTML
        end

        it { expect(rendered).to be == expected }
      end

      describe 'with leading whitespace' do
        let(:contents) do
          <<~HTML
            <p>


              Expected: true
                Actual: false
            </p>
          HTML
        end
        let(:expected) do
          <<~HTML
            <p>
              Expected: true
                Actual: false
            </p>
          HTML
        end

        it { expect(rendered).to be == expected }
      end

      describe 'with nested whitespace' do
        let(:contents) do
          <<~HTML
            <p>
              <span>
                Expected: true
                  Actual: false
              </span>
            </p>
          HTML
        end

        it { expect(rendered).to be == expected }

        describe 'with excessive whitespace' do
          let(:contents) do
            <<~HTML
              <p>
                <span>
                    Expected: true
                      Actual: false
                  </span>
              </p>
            HTML
          end
          let(:expected) do
            <<~HTML
              <p>
                <span>
                  Expected: true
                    Actual: false
                </span>
              </p>
            HTML
          end

          it { expect(rendered).to be == expected }
        end
      end

      describe 'with trailing whitespace' do
        let(:contents) do
          <<~HTML
            <p>
              Expected: true
                Actual: false

            </p>
          HTML
        end
        let(:expected) do
          <<~HTML
            <p>
              Expected: true
                Actual: false
            </p>
          HTML
        end

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a tag with short text' do
      let(:contents) { '<span>Ichi</span>' }

      it { expect(rendered).to be == expected }

      describe 'with whitespace' do
        let(:contents) { "<span>\tIchi  </span>" }

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a form with authenticity token' do
      let(:contents) do
        <<~HTML
          <form>
            <input type="hidden" name="authenticity_token" value="12345" autocomplete="off">

            <input type="text" name="username">

            <button type="submit">Submit</button>
          </form>
        HTML
      end
      let(:expected) do
        <<~HTML
          <form>
            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <input type="text" name="username">

            <button type="submit">Submit</button>
          </form>
        HTML
      end

      it { expect(rendered).to be == expected }
    end

    describe 'with a list of tags' do
      let(:contents) do
        <<~HTML
          <span>Ichi</span>
          <span>Ni</span>
          <span>San</span>
        HTML
      end
      let(:expected) do
        <<~HTML
          <span>Ichi</span>

          <span>Ni</span>

          <span>San</span>
        HTML
      end

      it { expect(rendered).to be == expected }

      describe 'with inconsistent whitespace' do
        let(:contents) do
          <<~HTML
            <span>Ichi</span>


              <span>Ni</span>
            <span>San</span>

          HTML
        end

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with a complex document' do
      let(:contents) do
        <<~HTML
          <footer class="footer has-text-centered">
            <div class="container">
              <nav class="breadcrumb has-arrow-separator" aria-label="breadcrumbs">
            <ul>
              <li>
            <a href="/">Home</a>
          </li>

              <li>
            <a href="/launch_sites">Launch Sites</a>
          </li>

              <li class="is-active">
            <a href="/launch_sites/zeppelins" aria-current="page">Zeppelins</a>
          </li>

            </ul>
          </nav>


              <hr class="is-fancy-hr">

              <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
            </div>
          </footer>
        HTML
      end
      let(:expected) do
        <<~HTML
          <footer class="footer has-text-centered">
            <div class="container">
              <nav class="breadcrumb has-arrow-separator" aria-label="breadcrumbs">
                <ul>
                  <li>
                    <a href="/">Home</a>
                  </li>

                  <li>
                    <a href="/launch_sites">Launch Sites</a>
                  </li>

                  <li class="is-active">
                    <a href="/launch_sites/zeppelins" aria-current="page">Zeppelins</a>
                  </li>
                </ul>
              </nav>

              <hr class="is-fancy-hr">

              <p>What Lies Beyond The Farthest Reaches Of The Skies?</p>
            </div>
          </footer>
        HTML
      end

      it { expect(rendered).to be == expected }
    end
  end
end
