# apps/api

Node.js Express API for apps and mobile (TypeScript).

Quickstart

- From repo root (recommended if using pnpm workspace):
  - pnpm install
  - pnpm --filter @sollu/api dev

- From apps/api directly:
  - pnpm install
  - pnpm run dev

Build and start

- pnpm run build
- pnpm start

Health endpoint

GET /health

Notes

- This project is set up for pnpm but will work with npm or yarn if you prefer (adjust commands accordingly).
- Add this package to your monorepo workspace configuration if you are using a workspace tool (pnpm/workspace: add to pnpm-workspace.yaml).
