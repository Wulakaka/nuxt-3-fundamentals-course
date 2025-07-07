<script setup>
import {
  autoUpdate,
  flip,
  offset,
  shift,
  useFloating,
  arrow,
} from "@floating-ui/vue";

const reference = ref(null);
const floating = ref(null);
const floatingArrow = ref(null);
const visible = ref(true);
const count = ref(0);
const toggle = () => {
  // visible.value = !visible.value;
  count.value++;
};
const {floatingStyles, middlewareData, placement} = useFloating(
  reference,
  floating,
  {
    placement: "bottom",
    middleware: [
      offset(10), // Offset the tooltip by 10 pixels
      flip(), // Enable flipping if there's not enough space
      shift(), // Shift the tooltip to fit within the viewport
      arrow({element: floatingArrow}),
    ],
    whileElementsMounted: autoUpdate,
  }
);

const staticSide = computed(
  () =>
    ({
      top: "bottom",
      right: "left",
      bottom: "top",
      left: "right",
    }[placement.value.split("-")[0]])
);

watchEffect(() => {
  console.log("placement", placement.value);
});

definePageMeta({
  layout: "plain",
});
</script>

<template>
  <div class="flex items-center justify-center h-screen">
    <div class="w-100 h-100 outline outline-gray-300 overflow-auto">
      <div class="h-200 w-200 flex items-center justify-center relative">
        <button
          ref="reference"
          class="px-4 rounded-2xl border border-solid border-violet-500"
          @click="toggle"
        >
          Button
        </button>
        <div
          v-if="visible"
          ref="floating"
          class="p-1 bg-amber-400 transition-all"
          :style="floatingStyles"
        >
          Tooltip{{
            Array.from({length: count})
              .map((_, i) => i + 1)
              .join(", ")
          }}
          <div
            ref="floatingArrow"
            class="absolute w-3 h-3 bg-amber-400"
            :style="{
              left:
                middlewareData.arrow?.x != null
                  ? `${middlewareData.arrow.x}px`
                  : '',
              top:
                middlewareData.arrow?.y != null
                  ? `${middlewareData.arrow.y}px`
                  : '',
              [staticSide]: '-4px',
            }"
          />
        </div>
      </div>
    </div>
  </div>
</template>
