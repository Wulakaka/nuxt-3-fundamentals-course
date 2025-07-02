<script setup>
const route = useRoute();

const {data, error} = await useFetch(
  `http://www.omdbapi.com/?apikey=e46ce174&i=${route.params.id}`,
  {
    key: `/movie/${route.params.id}`,
    pick: ["Title", "Plot", "Error"],
  }
);

if (error.value) {
  console.error("Error fetching movie data:", error.value);
}

if (data.value.Error === "Incorrect IMDb ID.") {
  showError({
    statusCode: 404,
    statusMessage: "Page not found",
  });
}
</script>

<template>
  <div>
    <pre>{{ data }}</pre>
  </div>
</template>

<style lang="scss" scoped></style>
