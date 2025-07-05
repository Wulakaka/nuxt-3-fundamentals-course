export const useUser = defineStore("user", () => {
  const isLoggedIn = ref(false);

  return {
    isLoggedIn,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useUser, import.meta.hot));
}
