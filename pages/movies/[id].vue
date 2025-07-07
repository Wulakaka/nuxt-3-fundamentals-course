<script setup>
const route = useRoute();

const {data, error} = await useFetch(
  `https://www.omdbapi.com/?apikey=e46ce174&i=${route.params.id}`,
  {
    key: `/movie/${route.params.id}`,
    pick: ["Title", "Plot", "Error", "Poster"],
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

useHead({
  title: data.value.Title,
  meta: [
    {
      name: "description",
      content: data.value.Plot,
    },
    {
      property: "og:description",
      content: data.value.Plot,
    },
    {
      property: "og:image",
      content: data.value.Poster,
    },
    {
      name: "twitter:card",
      content: "summary_large_image",
    },
  ],
});
</script>

<template>
  <div>
    <pre>{{ data }}</pre>
  </div>
</template>

<style lang="scss" scoped></style>
