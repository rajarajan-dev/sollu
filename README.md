# sollu

A pnpm + Turborepo monorepo with a React web app, Expo mobile app, and Express API.

## Structure

```
sollu/
├── apps/
│   ├── api/        # Express + TypeScript API
│   ├── web/        # React 19 + Vite
│   └── mobile/     # Expo SDK 57 + React Native (Expo Go compatible)
├── packages/
│   ├── config/     # Shared TypeScript configs (@repo/typescript-config)
│   ├── shared/     # Shared types and utilities (@repo/shared)
│   └── ui/         # Shared React UI components — web only (@repo/ui)
```

## Requirements

- Node ≥ 22
- pnpm 11.14.0

## Getting Started

```bash
# Install dependencies
pnpm install

# Run all apps in dev mode
pnpm dev

# Run individual apps
pnpm --filter @sollu/api dev
pnpm --filter @repo/web dev
pnpm --filter @repo/mobile start
```

The development URLs are:

- Web: <http://localhost:5173>
- API: <http://localhost:3000>
- API health check: <http://localhost:3000/health>

The mobile app starts Expo. Open it in Expo Go, or use a platform-specific command:

```bash
# iOS simulator
pnpm --filter @repo/mobile ios

# Android emulator
pnpm --filter @repo/mobile android

# Expo web
pnpm --filter @repo/mobile web
```

To use a different API port:

```bash
PORT=3001 pnpm --filter @sollu/api dev
```

## Development Commands

Run these commands from the repository root:

| Command             | Description                    |
| ------------------- | ------------------------------ |
| `pnpm dev`          | Start all apps in dev mode     |
| `pnpm build`        | Build all apps and packages    |
| `pnpm lint`         | Lint all packages              |
| `pnpm type-check`   | Type-check all packages        |
| `pnpm format`       | Format all files with Prettier |
| `pnpm format:check` | Check formatting               |
| `pnpm clean`        | Clean all build outputs        |

App-specific commands are available through pnpm filters. For example:

```bash
pnpm --filter @repo/web build
pnpm --filter @repo/web lint
pnpm --filter @sollu/api build
pnpm --filter @sollu/api start
pnpm --filter @repo/mobile type-check
```

## Packages

### `@repo/shared`

Shared TypeScript types (`Post`, `Author`) and utility functions (`formatDate`, `slugify`, `truncate`, `readingTime`). Used by both web and mobile.

### `@repo/ui`

Shared React UI components for the web app.

### `@repo/typescript-config`

Shared `tsconfig` bases: `base`, `react-vite`, `react-native`, `library`.

### `@sollu/api`

Express API used by the web and mobile apps. It currently exposes a root status route and `GET /health`.

## Notes

- All workspace packages expose TypeScript source directly — no pre-build step required.
- Mobile app is compatible with **Expo Go** — do not add `react-native-reanimated@4` or `react-native-worklets`.
- `@repo/ui` is web only — React Native uses different UI primitives.
- The API defaults to port `3000`; configure it with the `PORT` environment variable.
