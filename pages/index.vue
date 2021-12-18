<template>
  <div class="main">
    <div>Hello {{ count }}</div>
    <button @click="increment">Count up</button>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from '@nuxtjs/composition-api'

export default defineComponent({
  setup(props) {
    const count = ref(0)

    const increment = () => {
      count.value += 1
    }

    return {
      count,
      increment
    }
  }
})
</script>
