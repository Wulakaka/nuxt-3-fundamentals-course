<script setup lang="ts">
useHead({
  titleTemplate: (titleChunk) => {
    return titleChunk ? `${titleChunk} - My movie site` : "My movie site";
  },
});
</script>
<template>
  <div>
    <nav style="display: flex; gap: 10px">
      <nuxt-link to="/">Home</nuxt-link>
      <nuxt-link to="/movies">Movies</nuxt-link>
      <nuxt-link to="https://vueschool.io">Vue School</nuxt-link>
    </nav>
    <NuxtPage />
  </div>
</template>
