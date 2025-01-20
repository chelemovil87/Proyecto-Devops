import { defineConfig } from 'vite'
import reactRefresh from '@vitejs/plugin-react-refresh'

export default defineConfig({
  logLevel: 'info',
  plugins: [reactRefresh()],
  base: './',
  server: {
    host: process.env.VITE_HOST || '0.0.0.0',
    port: process.env.VITE_PORT ? Number(process.env.VITE_PORT) : 5173,
    hmr: {
      clientPort: process.env.VITE_CLIENT_PORT ? Number(process.env.VITE_CLIENT_PORT) : 5173
    },
    proxy: {
      '/api': {
        target: 'http://avatar-backend-container:5000',
        changeOrigin: true
      }
    }
  }
})
