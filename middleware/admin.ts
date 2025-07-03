export default defineNuxtRouteMiddleware((to, from) => {
  const isUserLoggedIn = false;
  if (!isUserLoggedIn) {
    return navigateTo("/login");
  }
});
