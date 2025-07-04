export default defineNuxtRouteMiddleware((to, from) => {
  console.log("global logger middleware", to.name, from.name);
});
