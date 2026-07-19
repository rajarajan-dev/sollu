import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import { resolve } from 'path'

export default defineConfig({
  plugins: [tailwindcss(), react()],
  resolve: {
    alias: {
      '@repo/shared': resolve(__dirname, '../../packages/shared/src/index.ts'),
      '@repo/ui': resolve(__dirname, '../../packages/ui/src/index.ts'),
    },
  },
})
