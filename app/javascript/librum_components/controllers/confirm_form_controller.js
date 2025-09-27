import { Controller } from '@hotwired/stimulus';

class ConfirmFormController extends Controller {
  static values = { message: String }

  submit(event) {
    if (confirm(this.messageValue)) { return; }

    event.preventDefault();
  }
}

export { ConfirmFormController }
