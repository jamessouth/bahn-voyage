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
      boxShadow: {
        voyage: 'inset 0 0 13px 11px #edddbbbb',
      },
      colors: {
        black: {
          dk: '#040306',
          lt: '#414745',
        },
        white: {
          lt: '#e1d8b8',
        },
        yellow: {
          rg: '#fcca5f',
        },
      },
      dropShadow: {
        h1: ['0 4px 3px rgba(225, 216, 184)', '0 2px 2px rgba(225, 216, 184)'],
      },
      fontFamily: {
        amar: 'Amarante, serif',
      },
      maxWidth: {
        360: '360px',
        // 'cont': '2000px',
      },
    },
  },
  plugins: [],
};
