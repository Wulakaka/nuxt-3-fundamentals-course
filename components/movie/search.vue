<script setup>
const query = ref("batman");
const apiKey = "e46ce174";
const movies = ref([]);

search();

async function search() {
  const {Search} = await $fetch(
    `http://www.omdbapi.com/?apikey=${apiKey}&s=${query.value}`
  );
  movies.value = Search;
}
</script>

<template>
  <div>
    <form @submit.prevent="search">
      <input v-model="query" type="text" placeholder="Search for a movie..." />
      <button type="submit">Search</button>
    </form>
    <ul style="list-style: none; display: flex; flex-wrap: wrap; gap: 10px">
      <li v-for="movie in movies" :key="movie.imdbID">
        <NuxtLink :to="{name: 'movies-id', params: {id: movie.imdbID}}">
          <img :src="movie.Poster" :alt="movie.title" />
        </NuxtLink>
      </li>
    </ul>
  </div>
</template>

<style scoped></style>
