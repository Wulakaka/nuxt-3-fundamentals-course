<script setup lang="ts">
const count = 40;

const list = new Array(count).fill(null).map((_, i) => ({
  id: i + 1,
  color: `hsl(${Math.floor((i / count) * 360)}, 100%, 40%)`,
}));
definePageMeta({
  layout: "plain",
});
</script>

<template>
  <div class="grid grid-cols-[repeat(8,1fr)] gap-4 h-[100vh] text-white">
    <div
      v-for="item in list"
      :key="item.id"
      class="text-[40px] flex items-center justify-center rounded-lg border-2 border-white border-dashed bg-[var(--color)] box-border"
      :style="{'--color': item.color}"
    >
      {{ 41 - item.id }}
    </div>
  </div>
</template>

<style scoped></style>
