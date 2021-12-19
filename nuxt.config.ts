import { NuxtConfig } from '@nuxt/types'

const config: NuxtConfig = {
  buildModules: [
    '@nuxt/typescript-build',
    '@nuxtjs/composition-api/module',
    '@nuxtjs/stylelint-module'
  ],

  components: true
}

export default config
