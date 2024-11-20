import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="enter-submit"
export default class extends Controller {
  static targets = ['submit']
  connect() {
  }

  checkKeyPress(event) {
    if (event.key === 'Enter' && event.metaKey) {
      if (this.submitTarget.disabled) return;

      this.submitTarget.disabled = true;
      event.preventDefault();
      this.element.requestSubmit();
    }
  }
}
