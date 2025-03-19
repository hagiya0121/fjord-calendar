import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["day", "name", "title", "url"];

  copy() {
    const formattedEntries = this.nameTargets.map((name, i) => {
      const nameText = name.textContent.trim();
      const titleText = this.titleTargets[i].textContent.trim();
      const url = this.urlTargets[i]?.href || "";

      return {
        day: parseInt(this.dayTargets[i].textContent.trim()),
        text: `  - :@${nameText}: ${nameText}: [${titleText}](${url})`,
      };
    });

    const dailyEntries = formattedEntries.reduce((acc, { day, text }) => {
      acc[day] ||= [];
      acc[day].push(text);
      return acc;
    }, {});

    const formattedText = Object.entries(dailyEntries)
      .map(([day, texts]) => `- ${day}日\n${texts.join("\n")}`)
      .join("\n");

    navigator.clipboard
      .writeText(formattedText)
      .then(() => alert("コピーしました！"))
      .catch(() => alert("コピーに失敗しました"));
  }
}
