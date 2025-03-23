const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        fadeOut: {
          "0%": { opacity: "1" },
          "25%": { opacity: "0.75" },
          "50%": { opacity: "0.5" },
          "75%": { opacity: "0.25" },
          "100%": { opacity: "0" },
        },
      },
      animation: {
        "fade-out-5s": "fadeOut 2s linear forwards",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
