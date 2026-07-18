# sollu

A pnpm + Turborepo monorepo with a React web app and Expo mobile app.

## Structure

```
sollu/
├── apps/
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

# Run web only
pnpm --filter @repo/web dev

# Run mobile (opens in Expo Go)
pnpm --filter @repo/mobile start
```

## Scripts

| Command           | Description                    |
| ----------------- | ------------------------------ |
| `pnpm dev`        | Start all apps in dev mode     |
| `pnpm build`      | Build all apps and packages    |
| `pnpm lint`       | Lint all packages              |
| `pnpm type-check` | Type-check all packages        |
| `pnpm format`     | Format all files with Prettier |
| `pnpm clean`      | Clean all build outputs        |

## Packages

### `@repo/shared`

Shared TypeScript types (`Post`, `Author`) and utility functions (`formatDate`, `slugify`, `truncate`, `readingTime`). Used by both web and mobile.

### `@repo/ui`

Shared React UI components (web only). Currently exports a `Button` component.

### `@repo/typescript-config`

Shared `tsconfig` bases: `base`, `react-vite`, `react-native`, `library`.

## Notes

- All workspace packages expose TypeScript source directly — no pre-build step required.
- Mobile app is compatible with **Expo Go** — do not add `react-native-reanimated@4` or `react-native-worklets`.
- `@repo/ui` is web only — React Native uses different UI primitives.
