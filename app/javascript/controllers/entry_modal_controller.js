import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  close() {
    this.element.classList.add("hidden");
  }

  closeOnOutsideClick(event) {
    if (event.target === this.element) {
      this.close();
    }
  }
}
