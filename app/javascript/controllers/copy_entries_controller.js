import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name", "title", "url"];

  copy() {
    const formattedText = this.nameTargets
      .map(
        (name, i) =>
          `* :@${name.textContent.trim()}: [${this.titleTargets[i].textContent.trim()}](${this.urlTargets[i]?.href || ""})`,
      )
      .join("\n");

    navigator.clipboard
      .writeText(formattedText)
      .then(() => {
        alert("コピーしました！");
      })
      .catch(() => {
        alert("コピーに失敗しました");
      });
  }
}
