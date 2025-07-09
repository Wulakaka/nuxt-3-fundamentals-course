<script setup lang="ts">
const left = 2213;
const top = 402;
const width = 800;
const height = 800;
const extract = `${left}_${top}_${width}_${height}`;

const modifiers = ref({
  // flip: true,
  extract,
  // blur: 5,
  // rotate: 45,
});
</script>

<template>
  <div>
    <NuxtPicture
      format="webp"
      src="/cat.jpg"
      width="300"
      fit="cover"
      :modifiers="modifiers"
    />
  </div>
</template>

<style scoped>
img {
  display: block;
  max-width: 100%;
}
</style>
