export interface useCycleListConfig<T> {
  fallbackIndex?: number;
  fallbackValue?: T;
}

export const useCycleList = <T>(
  list: MaybeRefOrGetter<T[]>,
  config?: useCycleListConfig<T>
) => {
  const useCycleListConfigDefaults: useCycleListConfig<T> = {
    fallbackIndex: undefined,
    fallbackValue: undefined,
  };

  const _config = {
    ...useCycleListConfigDefaults,
    ...config,
  };

  const _list = toRef(list) as Ref<T[]>;
  const activeIndex = ref(0);

  const state = computed({
    get() {
      return _list.value[activeIndex.value];
    },
    set(value) {
      const foundIndex = _list.value.indexOf(value);
      if (foundIndex !== -1) {
        activeIndex.value = foundIndex;
      } else {
        if (typeof _config.fallbackValue !== "undefined") {
          const foundFallbackIndex = _list.value.indexOf(_config.fallbackValue);
          if (foundFallbackIndex !== -1) {
            activeIndex.value = foundFallbackIndex;
          } else {
            throw new Error(
              `Fallback value "${_config.fallbackValue}" not found in the list.`
            );
          }
        } else {
          throw new Error(`Value "${value}" not found in the list.`);
        }
      }
    },
  });

  function add(index: number) {
    activeIndex.value =
      (activeIndex.value + index + _list.value.length) % _list.value.length;
  }

  function next() {
    add(1);
  }

  function prev() {
    add(-1);
  }

  function go(index: number) {
    if (index >= _list.value.length) {
      if (typeof _config.fallbackIndex !== "undefined") {
        activeIndex.value = _config.fallbackIndex;
      } else {
        throw new Error(`Index ${index} is out of bounds for the list.`);
      }
    } else {
      activeIndex.value = index;
    }
  }

  return {
    state,
    prev,
    next,
    go,
  };
};
