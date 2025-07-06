export const useUser = defineStore("user", () => {
  const isLoggedIn = ref(false);

  function login() {
    isLoggedIn.value = true;
    useRouter().push("/");
  }

  return {
    isLoggedIn,
    login,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useUser, import.meta.hot));
}
