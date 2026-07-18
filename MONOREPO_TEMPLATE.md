# Monorepo Setup Template — pnpm + Turborepo + React Web + Expo Mobile

> **Usage:** Give this file to Claude (or any AI) as a prompt.  
> Replace every `<PROJECT_NAME>`, `<GITHUB_URL>`, `<APP_SLUG>` placeholder with your own values before using.

---

## Project Overview

Create a **pnpm + Turborepo monorepo** with:

- `apps/web` — React 19 + Vite (web app)
- `apps/mobile` — Expo SDK 57 + React Native 0.86 (mobile app, Expo Go compatible)
- `packages/shared` — shared TypeScript types and utilities
- `packages/ui` — shared React UI components (web only)
- `packages/config` — shared TypeScript config bases

**Constraints:**

- Mobile app must work with **Expo Go** (no native build required for dev)
- Do NOT install `react-native-reanimated@4` or `react-native-worklets` (these require a native dev build)
- All workspace packages expose TypeScript source directly — no pre-build step
- Node ≥ 22, pnpm 11.14.0

---

## Step 1 — Repository Root

### `package.json`

```json
{
  "name": "<PROJECT_NAME>",
  "private": true,
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "lint": "turbo run lint",
    "type-check": "turbo run type-check",
    "format": "prettier --write \"**/*.{ts,tsx,js,jsx,json,css}\" --ignore-path .gitignore",
    "format:check": "prettier --check \"**/*.{ts,tsx,js,jsx,json,css}\" --ignore-path .gitignore",
    "clean": "turbo run clean"
  },
  "devEngines": {
    "packageManager": {
      "name": "pnpm",
      "version": "11.14.0",
      "onFail": "download"
    }
  },
  "devDependencies": {
    "prettier": "^3.6.2",
    "turbo": "^2.10.5",
    "typescript": "^7.0.2"
  },
  "packageManager": "pnpm@11.14.0"
}
```

### `pnpm-workspace.yaml`

```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### `.npmrc`

```ini
# Required for Metro bundler (Expo) to find transitive dependencies
# Without this, Metro cannot resolve packages in pnpm's virtual store (.pnpm/)
shamefully-hoist=true
strict-peer-dependencies=false
```

### `turbo.json`

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".expo/**", "!.expo/cache/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "type-check": {
      "dependsOn": ["^build"]
    },
    "clean": {
      "cache": false
    }
  }
}
```

### `tsconfig.json`

```json
{
  "files": [],
  "references": [{ "path": "packages/shared" }, { "path": "packages/ui" }, { "path": "apps/web" }]
}
```

### `.gitignore`

```
# Dependencies
node_modules/
.pnpm-store/

# Build outputs
dist/
build/
out/

# Expo / React Native
.expo/
*.jks
*.p8
*.p12
*.key
*.mobileprovision
*.orig.*
web-build/

# Turbo
.turbo/

# TypeScript
*.tsbuildinfo

# Environment
.env
.env.local
.env.*.local
!.env.example

# Logs
*.log
npm-debug.log*
pnpm-debug.log*

# OS
.DS_Store
Thumbs.db

# Coverage
coverage/
```

### `.prettierrc`

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSameLine": false,
  "arrowParens": "always"
}
```

---

## Step 2 — `packages/config` → `@repo/typescript-config`

### `packages/config/package.json`

```json
{
  "name": "@repo/typescript-config",
  "version": "0.0.0",
  "private": true,
  "license": "MIT",
  "exports": {
    "./base": "./base.json",
    "./react-vite": "./react-vite.json",
    "./react-native": "./react-native.json",
    "./library": "./library.json"
  }
}
```

### `packages/config/base.json`

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "strict": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  }
}
```

### `packages/config/react-vite.json`

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "target": "es2023",
    "lib": ["ES2023", "DOM", "DOM.Iterable"],
    "module": "esnext",
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "erasableSyntaxOnly": true
  }
}
```

### `packages/config/react-native.json`

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "target": "esnext",
    "lib": ["esnext"],
    "module": "esnext",
    "moduleResolution": "bundler",
    "jsx": "react-native",
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### `packages/config/library.json`

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "target": "es2022",
    "lib": ["ES2022"],
    "module": "esnext",
    "moduleResolution": "bundler",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "noEmit": false
  }
}
```

---

## Step 3 — `packages/shared` → `@repo/shared`

### `packages/shared/package.json`

```json
{
  "name": "@repo/shared",
  "version": "0.0.0",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "exports": {
    ".": "./src/index.ts"
  },
  "scripts": {
    "type-check": "tsc --noEmit"
  },
  "devDependencies": {
    "typescript": "^7.0.2"
  }
}
```

### `packages/shared/tsconfig.json`

```json
{
  "compilerOptions": {
    "strict": true,
    "target": "es2022",
    "lib": ["ES2022"],
    "module": "esnext",
    "moduleResolution": "bundler",
    "skipLibCheck": true,
    "declaration": true,
    "declarationMap": true,
    "noEmit": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
```

### `packages/shared/src/types/index.ts`

```ts
export interface Post {
  id: string
  title: string
  slug: string
  content: string
  excerpt: string
  publishedAt: string
  updatedAt?: string
  author: Author
  tags: string[]
  coverImage?: string
}

export interface Author {
  id: string
  name: string
  bio: string
  avatar?: string
  socials?: {
    twitter?: string
    github?: string
    linkedin?: string
  }
}
```

### `packages/shared/src/utils/index.ts`

```ts
export function formatDate(dateString: string, locale = 'en-US'): string {
  return new Date(dateString).toLocaleDateString(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

export function slugify(text: string): string {
  return text
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '')
    .replace(/[\s_-]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

export function truncate(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text
  return text.slice(0, maxLength).trimEnd() + '…'
}

export function readingTime(content: string): number {
  const wordsPerMinute = 200
  const wordCount = content.trim().split(/\s+/).length
  return Math.ceil(wordCount / wordsPerMinute)
}
```

### `packages/shared/src/index.ts`

```ts
export type { Post, Author } from './types'
export { formatDate, slugify, truncate, readingTime } from './utils'
```

---

## Step 4 — `packages/ui` → `@repo/ui`

### `packages/ui/package.json`

```json
{
  "name": "@repo/ui",
  "version": "0.0.0",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "exports": {
    ".": "./src/index.ts"
  },
  "scripts": {
    "type-check": "tsc --noEmit"
  },
  "peerDependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "devDependencies": {
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "typescript": "^7.0.2"
  }
}
```

### `packages/ui/tsconfig.json`

```json
{
  "compilerOptions": {
    "strict": true,
    "target": "es2022",
    "lib": ["ES2022", "DOM"],
    "module": "esnext",
    "moduleResolution": "bundler",
    "skipLibCheck": true,
    "jsx": "react-jsx",
    "declaration": true,
    "declarationMap": true,
    "noEmit": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
```

### `packages/ui/src/components/button.tsx`

```tsx
import type { ButtonHTMLAttributes } from 'react'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
}

export function Button({
  variant = 'primary',
  size = 'md',
  className,
  children,
  ...props
}: ButtonProps) {
  return (
    <button data-variant={variant} data-size={size} className={className} {...props}>
      {children}
    </button>
  )
}
```

### `packages/ui/src/index.ts`

```ts
export { Button, type ButtonProps } from './components/button'
```

---

## Step 5 — `apps/web` → `@repo/web`

Use **Vite + React** scaffolded with:

```bash
pnpm create vite apps/web --template react-ts
```

Then override these files:

### `apps/web/package.json`

```json
{
  "name": "@repo/web",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "lint": "eslint .",
    "preview": "vite preview",
    "type-check": "tsc -b"
  },
  "dependencies": {
    "@repo/shared": "workspace:*",
    "@repo/ui": "workspace:*",
    "react": "^19.2.7",
    "react-dom": "^19.2.7"
  },
  "devDependencies": {
    "@eslint/js": "^10.0.1",
    "@types/node": "^24.0.0",
    "@types/react": "^19.2.17",
    "@types/react-dom": "^19.2.3",
    "@vitejs/plugin-react": "^6.0.3",
    "eslint": "^10.6.0",
    "eslint-plugin-react-hooks": "^7.1.1",
    "eslint-plugin-react-refresh": "^0.5.3",
    "globals": "^17.7.0",
    "typescript": "~6.0.2",
    "typescript-eslint": "^8.62.0",
    "vite": "^8.1.1"
  }
}
```

### `apps/web/vite.config.ts`

```ts
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
```

### `apps/web/tsconfig.app.json`

Add `paths` to the existing compilerOptions (no `baseUrl` — deprecated in TS7):

```json
{
  "compilerOptions": {
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "target": "es2023",
    "lib": ["ES2023", "DOM"],
    "module": "esnext",
    "types": ["vite/client"],
    "allowArbitraryExtensions": true,
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "erasableSyntaxOnly": true,
    "noFallthroughCasesInSwitch": true,
    "paths": {
      "@repo/shared": ["../../packages/shared/src/index.ts"],
      "@repo/ui": ["../../packages/ui/src/index.ts"]
    }
  },
  "include": ["src"]
}
```

---

## Step 6 — `apps/mobile` → `@repo/mobile`

### IMPORTANT — Scaffold correctly

Run `create-expo-app` using `pnpm dlx` (NOT `npx` — conflicts with root `packageManager`):

```bash
cd apps
pnpm dlx create-expo-app@latest mobile --template blank-typescript
# Select: Latest (SDK 57)
# When asked to init git repo: Y (skip — we have one already)
```

After scaffolding, **delete the nested `.git`** inside `apps/mobile` or it will be committed as a git submodule:

```bash
rm -rf apps/mobile/.git
```

Then override these files:

### `apps/mobile/package.json`

```json
{
  "name": "@repo/mobile",
  "version": "1.0.0",
  "main": "index.ts",
  "dependencies": {
    "@repo/shared": "workspace:*",
    "expo": "~57.0.7",
    "expo-status-bar": "~57.0.1",
    "react": "19.2.3",
    "react-native": "0.86.0"
  },
  "devDependencies": {
    "@types/react": "~19.2.2",
    "typescript": "~6.0.3"
  },
  "scripts": {
    "start": "expo start",
    "ios": "expo run:ios",
    "android": "expo run:android",
    "web": "expo start --web",
    "type-check": "tsc --noEmit",
    "lint": "expo lint"
  },
  "private": true
}
```

### `apps/mobile/app.json`

```json
{
  "expo": {
    "name": "<PROJECT_NAME>",
    "slug": "<APP_SLUG>",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "automatic",
    "newArchEnabled": true,
    "ios": {
      "supportsTablet": true
    },
    "android": {
      "adaptiveIcon": {
        "backgroundColor": "#ffffff",
        "foregroundImage": "./assets/android-icon-foreground.png"
      }
    },
    "web": {
      "bundler": "metro",
      "favicon": "./assets/favicon.png"
    }
  }
}
```

### `apps/mobile/metro.config.js`

```js
const { getDefaultConfig } = require('expo/metro-config')
const path = require('path')

const projectRoot = __dirname
const monorepoRoot = path.resolve(projectRoot, '../..')

const config = getDefaultConfig(projectRoot)

// Watch all files in the monorepo so Metro picks up package changes
config.watchFolders = [monorepoRoot]

// Resolve packages: app first → root → pnpm virtual store
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(monorepoRoot, 'node_modules'),
  // pnpm stores transitive deps (e.g. @expo/log-box) here
  path.resolve(monorepoRoot, 'node_modules/.pnpm/node_modules'),
]

// Force React to always resolve from the app — prevents duplicate instances
// (duplicate React = "Object is not a function" crash)
config.resolver.extraNodeModules = {
  react: path.resolve(projectRoot, 'node_modules/react'),
  'react-native': path.resolve(projectRoot, 'node_modules/react-native'),
}

module.exports = config
```

### `apps/mobile/babel.config.js`

```js
module.exports = function (api) {
  api.cache(true)
  return {
    presets: ['babel-preset-expo'],
  }
}
```

### `apps/mobile/tsconfig.json`

```json
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "paths": {
      "@repo/shared": ["../../packages/shared/src/index.ts"]
    }
  }
}
```

### `apps/mobile/App.tsx` (starter)

```tsx
import { StatusBar } from 'expo-status-bar'
import { StyleSheet, Text, View } from 'react-native'
import { formatDate } from '@repo/shared'

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}><PROJECT_NAME></Text>
      <Text style={styles.date}>{formatDate(new Date().toISOString())}</Text>
      <StatusBar style="auto" />
    </View>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff', alignItems: 'center', justifyContent: 'center', gap: 8 },
  title: { fontSize: 28, fontWeight: '700' },
  date: { fontSize: 13, color: '#999' },
})
```

---

## Step 7 — Install & Verify

```bash
# From the repo root
pnpm install

# Verify workspace links
pnpm ls -r --depth 0

# Type-check shared package
pnpm --filter @repo/shared type-check

# Type-check web app (confirms @repo/shared and @repo/ui resolve)
pnpm --filter @repo/web type-check

# Start mobile (must open in Expo Go without errors)
pnpm --filter @repo/mobile start
```

### Expected `pnpm ls` output

```
@repo/mobile    → @repo/shared: link:../../packages/shared  ✓
@repo/web       → @repo/shared: link:../../packages/shared  ✓
                → @repo/ui:     link:../../packages/ui      ✓
```

---

## Step 8 — Git Push

```bash
git init
git remote add origin <GITHUB_URL>
git add -A
git commit -m "feat: initial monorepo setup"
git push -u origin main
```

⚠️ **If `apps/mobile` shows as mode `160000`** (submodule) in the commit output, fix it:

```bash
git rm --cached apps/mobile
rm -rf apps/mobile/.git
git add apps/mobile
git commit --amend --no-edit
git push --force-with-lease
```

---

## Known Issues & Fixes

### `@repo/shared` not found (404 from npm)

`packages/shared/package.json` must be at the **package root**, not inside `src/`. pnpm workspace glob `packages/*` looks for `package.json` one level deep.

### `[runtime not ready]: TypeError: Object is not a function`

Caused by `react-native-reanimated@4` or `react-native-worklets` — both require native C++ modules not present in Expo Go.  
**Fix:** Do NOT add these packages if you want Expo Go compatibility. If you need them, run `expo run:ios` instead of `expo start`.

### `Unable to resolve "@expo/log-box"` (Metro)

pnpm's virtual store (`.pnpm/`) doesn't hoist all transitive deps automatically.  
**Fix:** The `node_modules/.pnpm/node_modules` entry in `metro.config.js` `nodeModulesPaths` resolves this.

### `baseUrl is deprecated` (TypeScript 7)

Do NOT use `"baseUrl": "."` in `tsconfig.app.json`. TypeScript 7 deprecated it. Use `paths` alone — they resolve relative to the tsconfig file location.

### `pnpm reset-project` not found

Run it scoped: `pnpm --filter @repo/mobile reset-project` — not from the root (no such script at root level).

### `create-expo-app` fails with `EBADDEVENGINES`

Use `pnpm dlx create-expo-app` instead of `npx create-expo-app`. The root `package.json#packageManager: pnpm` conflicts with npm.

---

## Workspace Dependency Rules

- Use `"workspace:*"` for internal packages in `dependencies`
- Packages expose TS source directly (`"main": "./src/index.ts"`) — no build step
- `@repo/ui` is **web only** — do not add to `@repo/mobile` (React Native uses different UI primitives)
- If adding a new package: create dir → package.json → src/index.ts → tsconfig.json → run `pnpm install`

---

## Adding Navigation to Mobile (after initial setup)

### Option A — Expo Go compatible (React Navigation)

```bash
pnpm --filter @repo/mobile add @react-navigation/native @react-navigation/native-stack react-native-screens react-native-safe-area-context
```

### Option B — File-based routing (requires native dev build)

```bash
pnpm --filter @repo/mobile add expo-router react-native-screens react-native-safe-area-context react-native-gesture-handler react-native-reanimated
pnpm --filter @repo/mobile ios   # first run compiles native modules
```

Change `"main"` in `package.json` from `"index.ts"` to `"expo-router/entry"`.
