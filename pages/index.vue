<script setup lang="ts">
import {useCycleList} from "~/composables/useCycleList";

const {prev, next, state, go} = useCycleList(
  () => ["Dog", "Cat", "Fish", "Bird", "Hamster", "Rabbit"],
  {
    fallbackIndex: 0,
    fallbackValue: "Cat",
  }
);

state.value = "Hawk"; // Set initial state to "Cat"

const goto = ref(0);
</script>

<template>
  <div>
    {{ state }}
    <br />
    <button @click="prev">Previous</button>
    <button @click="next">Next</button>
    <br />
    <input v-model="goto" type="number" />
    <button @click="go(goto)">go to {{ goto }}</button>
  </div>
</template>

<style scoped>
@reference "tailwindcss";

button {
  @apply text-white px-4 py-2 rounded border border-gray-300 bg-blue-500 hover:bg-blue-600;
}
</style>
