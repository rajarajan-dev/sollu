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
