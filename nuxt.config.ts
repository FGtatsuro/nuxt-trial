import { NuxtConfig } from '@nuxt/types'

const config: NuxtConfig = {
  buildModules: [
    '@nuxt/typescript-build',
    '@nuxtjs/composition-api/module'
  ]
}

export default config
