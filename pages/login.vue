<script setup lang="ts">
definePageMeta({
  layout: "plain",
});

const user = useUser();
</script>

<template>
  <div>
    <h1>Page: login</h1>
    <form @submit.prevent="user.login">
      <label>
        <span>Username</span>
        <input type="text" name="username" placeholder="Enter your username" />
      </label>
      <label>
        <span>Password</span>
        <input
          type="password"
          name="password"
          placeholder="Enter your password"
        />
      </label>
      <button type="submit">Login</button>
    </form>
  </div>
</template>

<style scoped></style>
