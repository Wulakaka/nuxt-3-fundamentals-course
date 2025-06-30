<script setup lang="ts">
const route = useRoute();
const {data} = useAsyncData(`/movie/${route.params.id}`, () =>
  $fetch(`http://www.omdbapi.com/?apikey=e46ce174&i=${route.params.id}`)
);
</script>

<template>
  <div>
    <pre>{{ data }}</pre>
  </div>
</template>

<style lang="scss" scoped></style>
