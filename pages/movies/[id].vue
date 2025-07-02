<script setup>
const route = useRoute();

const {data} = await useFetch(
  `http://www.omdbapi.com/?apikey=e46ce174&i=${route.params.id}`,
  {
    key: `/movie/${route.params.id}`,
    pick: ["Title", "Plot"],
  }
);
</script>

<template>
  <div>
    <pre>{{ data }}</pre>
  </div>
</template>

<style lang="scss" scoped></style>
