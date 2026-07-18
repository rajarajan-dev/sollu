import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { resolve } from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@repo/shared': resolve(__dirname, '../../packages/shared/src/index.ts'),
      '@repo/ui': resolve(__dirname, '../../packages/ui/src/index.ts'),
    },
  },
})
