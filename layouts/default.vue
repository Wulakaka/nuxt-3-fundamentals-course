<script setup lang="ts"></script>

<template>
  <div>
    <nav style="display: flex; gap: 10px">
      <nuxt-link to="/">Home</nuxt-link>
      <nuxt-link to="/movies">Movies</nuxt-link>
      <nuxt-link to="https://vueschool.io">Vue School</nuxt-link>
      hello
    </nav>
    <slot />
  </div>
</template>

<style scoped></style>
