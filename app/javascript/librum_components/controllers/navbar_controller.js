import { Controller } from '@hotwired/stimulus';

class NavbarController extends Controller {
  static targets = ['button', 'menu'];

  toggle() {
    const button = this.buttonTarget;
    const menu = this.menuTarget;

    button.classList.toggle('is-active');
    menu.classList.toggle('is-active');
  }
}

export { NavbarController }
