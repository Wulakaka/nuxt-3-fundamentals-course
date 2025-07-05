<script setup lang="ts">
const list = new Array(40).fill(null).map((_, i) => ({
  id: i + 1,
  color: `hsl(${Math.floor(Math.random() * 360)}, 100%, 50%)`,
}));

definePageMeta({
  layout: "plain",
});
</script>

<template>
  <div
    class="grid grid-cols-[repeat(8,1fr)] grid-rows-5 gap-4 p-4 h-[100vh] text-white"
  >
    <div
      v-for="item in list"
      :key="item.id"
      class="text-[30px] flex items-center justify-center rounded-lg"
      :style="{backgroundColor: item.color}"
    >
      {{ item.id }}
    </div>
  </div>
</template>

<style scoped></style>
