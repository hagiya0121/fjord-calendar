import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["img"];

  connect() {
    this.imgTargets.forEach((img) => {
      const fallback = () => {
        img.src = img.dataset.fallbackSrc;
        img.onerror = null;
      };

      img.onerror = fallback;

      if (img.complete && img.naturalWidth === 0) {
        fallback();
      }
    });
  }
}
