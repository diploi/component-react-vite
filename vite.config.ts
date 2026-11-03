import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  // Diploi sets PORT to the port of the component's host in diploi.yaml
  server: { port: Number(process.env.PORT) || 5173, strictPort: true },
});
