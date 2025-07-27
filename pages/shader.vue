<script setup>
import HeroContent from "~/components/HeroContent.vue";
import WegGlShader from "~/components/WebGlShader.vue";

definePageMeta({
  layout: "plain",
  title: "WebGL2 Shader Example",
});

const maskState = ref(0.0);

function handleHoverChange(isHovered) {
  maskState.value = isHovered ? 1.0 : 0.0;
}
</script>

<template>
  <div>
    <WegGlShader :mask-state="maskState">
      <img src="@/assets/img/image.png" />
    </WegGlShader>
    <HeroContent @hover-change="handleHoverChange" />
    <div class="w-[300px]">
      <img src="@/assets/img/image.png" />
    </div>
  </div>
</template>

<style scoped></style>
