import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    document.addEventListener("click", this.handleClickOutside);
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside);
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden");
  }

  handleClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  };
}
