module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
  },

  parserOptions: {
    parser: '@typescript-eslint/parser',
    project: './tsconfig.json',
    extraFileExtensions: [
      '.vue',
    ],
  },
  plugins: [
    '@typescript-eslint',
  ],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    '@nuxtjs/eslint-config-typescript',
    'plugin:nuxt/recommended',
  ],
  rules: {
    '@typescript-eslint/space-before-function-paren': 'off',
    '@typescript-eslint/restrict-template-expressions': 'off',
    'no-multiple-empty-lines': 'off',
  },
}
