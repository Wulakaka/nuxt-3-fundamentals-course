<script setup>
import HeroContent from "~/components/HeroContent.vue";
import WegGlShader from "~/components/WebGlShader.vue";

definePageMeta({
  layout: "plain",
  title: "WebGL2 Shader Example",
});

const circleSize = ref(0.1);
const circleColor = ref("#ffffff");

const maskState = ref(0.0);

function handleHoverChange(isHovered) {
  maskState.value = isHovered ? 1.0 : 0.0;
}
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
    <WegGlShader :mask-state="maskState">
      <img src="https://picsum.photos/512" crossorigin="anonymous" />
    </WegGlShader>
    <HeroContent @hover-change="handleHoverChange" />
  </div>
</template>

<style scoped></style>
