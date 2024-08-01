/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './src/**/*.res.mjs'],
  theme: {
    extend: {
      backgroundImage: {
        entry_desktop: 'url(/entryDesktop.jpg)',
        entry_mob_tall: 'url(/entryMobTall.jpg)',
        entry_mob_wide: 'url(/entryMobWide.jpg)',
      },
    },
  },
  plugins: [],
};
