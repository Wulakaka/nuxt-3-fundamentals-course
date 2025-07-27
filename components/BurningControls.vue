<script setup lang="ts">
const emit = defineEmits<{
  "burn-intensity-change": [intensity: number];
  "start-burning": [];
  "stop-burning": [];
}>();

const props = defineProps<{
  burnIntensity: number;
  isAutoMode: boolean;
}>();

const sliderValue = ref(props.burnIntensity);

watch(
  () => props.burnIntensity,
  (newValue) => {
    sliderValue.value = newValue;
  }
);

function handleSliderChange() {
  // 手动滑动时暂停自动模式
  if (props.isAutoMode) {
    emit("stop-burning");
  }
  emit("burn-intensity-change", sliderValue.value);
}

function toggleAutoMode() {
  if (props.isAutoMode) {
    emit("stop-burning");
  } else {
    emit("start-burning");
  }
}
</script>

<template>
  <div class="burning-controls">
    <div class="control-section">
      <h3 class="control-title">纸张燃烧控制</h3>

      <div class="control-group">
        <label for="burn-slider" class="control-label">
          燃烧强度: {{ Math.round(burnIntensity * 100) }}%
        </label>
        <input
          id="burn-slider"
          v-model="sliderValue"
          type="range"
          min="0"
          max="1"
          step="0.01"
          class="burn-slider"
          @input="handleSliderChange"
        />
      </div>

      <div class="control-group">
        <button
          class="control-button"
          :class="{active: isAutoMode}"
          @click="toggleAutoMode"
        >
          {{ isAutoMode ? "停止自动燃烧" : "开始自动燃烧" }}
        </button>
      </div>

      <div class="instructions">
        <p class="instruction-text">
          <strong>交互说明:</strong>
        </p>
        <ul class="instruction-list">
          <li>移动鼠标到画布上可以控制燃烧起点</li>
          <li>拖动滑块手动控制燃烧强度</li>
          <li>点击自动燃烧按钮观看动画效果</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style scoped>
.burning-controls {
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
  border-radius: 12px;
  padding: 24px;
  margin: 20px 0;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  border: 1px solid #333;
}

.control-section {
  max-width: 400px;
}

.control-title {
  color: #ff6b35;
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 20px;
  text-shadow: 0 2px 4px rgba(255, 107, 53, 0.3);
}

.control-group {
  margin-bottom: 20px;
}

.control-label {
  display: block;
  color: #e0e0e0;
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 8px;
}

.burn-slider {
  width: 100%;
  height: 8px;
  border-radius: 4px;
  background: linear-gradient(to right, #333 0%, #ff6b35 50%, #ff2b06 100%);
  outline: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.burn-slider::-webkit-slider-thumb {
  appearance: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff6b35, #ff2b06);
  cursor: pointer;
  border: 2px solid #fff;
  box-shadow: 0 2px 8px rgba(255, 107, 53, 0.4);
  transition: all 0.3s ease;
}

.burn-slider::-webkit-slider-thumb:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.6);
}

.control-button {
  background: linear-gradient(135deg, #ff6b35, #ff2b06);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
}

.control-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(255, 107, 53, 0.4);
}

.control-button.active {
  background: linear-gradient(135deg, #4caf50, #45a049);
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
}

.control-button.active:hover {
  box-shadow: 0 6px 16px rgba(76, 175, 80, 0.4);
}

.instructions {
  margin-top: 24px;
  padding: 16px;
  background: rgba(255, 107, 53, 0.1);
  border-radius: 8px;
  border-left: 4px solid #ff6b35;
}

.instruction-text {
  color: #ff6b35;
  font-weight: 600;
  margin-bottom: 8px;
}

.instruction-list {
  color: #ccc;
  padding-left: 20px;
  line-height: 1.6;
}

.instruction-list li {
  margin-bottom: 4px;
}
</style>
