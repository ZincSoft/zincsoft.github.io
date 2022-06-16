/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js}"],
  theme: {
    extend: {
      backgroundImage: (theme) => ({
        land: "url('/assets/imgs/land.jpg')",
        forest: "url('/assets/imgs/forest.jpg')",
        clouds: "url('/assets/imgs/clouds.png')",
        farm: "linear-gradient( rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5) ), url('/assets/imgs/farm.jpg')",
      }),
      fontFamily: {
        'display': ["Roboto"],
        'sub-mono': ["Source Code Pro"],
      },
      fontSize: {
        'huge': '20rem',
        'giant': '35rem',
      },
      colors: {
        'orange_yellow': '#EAB308',
        'skobeloff': '#297373',
        'persimmon': '#E55812',
        'timberwolf': '#E5DADA',
        'rich_black': '#02040F',
      }
    },
  },
  plugins: [],
}

