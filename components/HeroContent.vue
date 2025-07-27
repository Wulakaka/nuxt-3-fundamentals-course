<script setup lang="ts">
defineEmits<{
  "hover-change": [isHovered: boolean];
}>();
</script>

<template>
  <div
    @mouseenter="$emit('hover-change', true)"
    @mouseleave="$emit('hover-change', false)"
  >
    hover me
  </div>
</template>

<style scoped></style>
