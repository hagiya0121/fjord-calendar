import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["img"];

  connect() {
    this.imgTargets.forEach((img) => {
      img.onerror = () => {
        img.src = img.dataset.fallbackSrc;
        img.onerror = null;
      };
    });
  }
}
