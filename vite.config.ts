import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';

// https://vite.dev/config/
export default defineConfig({
  server: {
    port: parseInt(process.env.PORT || '8080'),
    allowedHosts: ['.diploi.me'],
  },
  plugins: [react()],
});
