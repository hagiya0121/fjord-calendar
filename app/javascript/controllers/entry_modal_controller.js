import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  closeOnOutsideClick(event) {
    if (event.target === this.element) {
      this.element.classList.add("hidden");
    }
  }
}
