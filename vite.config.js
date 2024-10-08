import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

// https://vitejs.dev/config/
export default defineConfig({
  build: { sourcemap: false },
  plugins: [
    react({
      include: ['**/*.res.mjs'],
    }),
  ],
});
