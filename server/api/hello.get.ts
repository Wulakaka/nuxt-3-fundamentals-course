export default defineEventHandler((event) => {
  return {
    message: "Hello, world!",
    query: getQuery(event),
  };
});
