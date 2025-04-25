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
      colors: {
        ochre: "#DDA75B",
        "light-ochre": "#FFF8E7",
        "dark-ochre": "#C88A41",
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
        "fade-out": "fadeOut 2s linear forwards",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
