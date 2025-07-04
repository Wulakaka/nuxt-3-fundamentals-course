<script setup lang="ts">
const isLoggedIn = useIsLoggedIn();
</script>

<template>
  <div>
    <nav style="display: flex; gap: 10px">
      <nuxt-link to="/">Home</nuxt-link>
      <nuxt-link to="/movies">Movies</nuxt-link>
      <nuxt-link to="https://vueschool.io">Vue School</nuxt-link>
      <nuxt-link v-if="!isLoggedIn" to="/login">Login</nuxt-link>
      <a v-else href="#" @click.prevent="isLoggedIn = false">Logout</a>
    </nav>
    <slot />
  </div>
</template>

<style scoped></style>
