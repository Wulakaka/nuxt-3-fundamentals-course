<script setup>
import WegGlShader from "~/components/WebGlShader.vue";
definePageMeta({
  layout: "plain",
  title: "WebGL2 Shader Example",
});

const circleSize = ref(0.1);
const circleColor = ref("#ffffff");
</script>

<template>
  <div>
    <input
      v-model.number="circleSize"
      type="range"
      min="0.01"
      max="0.5"
      step="0.01"
    />
    <input v-model="circleColor" type="color" />
    <WegGlShader :circle-size="circleSize" :circle-color="circleColor" />
  </div>
</template>

<style scoped></style>
