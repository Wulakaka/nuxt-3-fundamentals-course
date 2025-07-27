<script setup>
import BurningPaperShader from "~/components/BurningPaperShader.vue";
import BurningControls from "~/components/BurningControls.vue";

definePageMeta({
  layout: "plain",
  title: "纸张燃烧效果 - WebGL2 Shader",
});

const burnIntensity = ref(0.0);
const isAutoMode = ref(false);
let autoModeInterval = null;

function handleBurnIntensityChange(intensity) {
  burnIntensity.value = intensity;
}

function startAutoBurning() {
  isAutoMode.value = true;

  // 创建一个平滑的自动燃烧动画
  const startTime = Date.now();
  const duration = 8000; // 8秒完成一个完整的燃烧循环

  function animate() {
    if (!isAutoMode.value) return;

    const elapsed = Date.now() - startTime;
    const progress = (elapsed % duration) / duration;

    // 使用正弦波形创建平滑的燃烧动画
    // 前70%时间用于燃烧，后30%时间用于恢复
    let intensity;
    if (progress < 0.7) {
      // 燃烧阶段：从0到1
      const burnProgress = progress / 0.7;
      intensity = smoothstep(0, 1, burnProgress);
    } else {
      // 恢复阶段：从1到0
      const restoreProgress = (progress - 0.7) / 0.3;
      intensity = smoothstep(1, 0, restoreProgress);
    }

    burnIntensity.value = intensity;
    autoModeInterval = requestAnimationFrame(animate);
  }

  animate();
}

function stopAutoBurning() {
  isAutoMode.value = false;
  if (autoModeInterval) {
    cancelAnimationFrame(autoModeInterval);
    autoModeInterval = null;
  }
}

// 平滑插值函数
function smoothstep(min, max, value) {
  const t = Math.max(0, Math.min(1, (value - min) / (max - min)));
  return t * t * (3 - 2 * t);
}

// 组件卸载时清理动画
onUnmounted(() => {
  stopAutoBurning();
});
</script>

<template>
  <div class="shader-page">
    <header class="page-header">
      <h1 class="page-title">纸张燃烧效果</h1>
      <p class="page-description">
        使用 WebGL2 Fragment Shader 实现的真实纸张燃烧效果演示
      </p>
    </header>

    <main class="page-content">
      <div class="shader-container">
        <BurningPaperShader :mask-state="burnIntensity">
          <img src="@/assets/img/image.png" alt="要燃烧的纸张图片" />
        </BurningPaperShader>
      </div>

      <BurningControls
        :burn-intensity="burnIntensity"
        :is-auto-mode="isAutoMode"
        @burn-intensity-change="handleBurnIntensityChange"
        @start-burning="startAutoBurning"
        @stop-burning="stopAutoBurning"
      />

      <section class="technical-info">
        <h2 class="section-title">技术实现</h2>
        <div class="info-grid">
          <div class="info-card">
            <h3 class="info-title">Shader 特性</h3>
            <ul class="info-list">
              <li>多层噪声函数生成自然的燃烧图案</li>
              <li>实时动画效果与时间同步</li>
              <li>基于距离的渐变燃烧边缘</li>
              <li>动态余烬发光效果</li>
            </ul>
          </div>

          <div class="info-card">
            <h3 class="info-title">视觉效果</h3>
            <ul class="info-list">
              <li>真实的纸张炭化色彩变化</li>
              <li>热浪扭曲效果</li>
              <li>透明度渐变模拟烧穿</li>
              <li>余烬脉冲动画</li>
            </ul>
          </div>

          <div class="info-card">
            <h3 class="info-title">交互功能</h3>
            <ul class="info-list">
              <li>鼠标位置控制燃烧起点</li>
              <li>手动强度调节滑块</li>
              <li>自动循环燃烧模式</li>
              <li>实时响应用户输入</li>
            </ul>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.shader-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 50%, #0f0f0f 100%);
  color: #fff;
  padding: 20px;
}

.page-header {
  text-align: center;
  margin-bottom: 40px;
}

.page-title {
  font-size: 3rem;
  font-weight: 700;
  background: linear-gradient(135deg, #ff6b35, #ff2b06);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 12px;
  text-shadow: 0 4px 8px rgba(255, 107, 53, 0.3);
}

.page-description {
  font-size: 1.2rem;
  color: #ccc;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.6;
}

.page-content {
  max-width: 1200px;
  margin: 0 auto;
}

.shader-container {
  display: flex;
  justify-content: center;
  margin-bottom: 40px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.02);
  border-radius: 16px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.technical-info {
  margin-top: 60px;
}

.section-title {
  font-size: 2rem;
  font-weight: 600;
  color: #ff6b35;
  text-align: center;
  margin-bottom: 30px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin-top: 30px;
}

.info-card {
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
  border-radius: 12px;
  padding: 24px;
  border: 1px solid #333;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.info-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(255, 107, 53, 0.1);
}

.info-title {
  font-size: 1.3rem;
  font-weight: 600;
  color: #ff6b35;
  margin-bottom: 16px;
}

.info-list {
  list-style: none;
  padding: 0;
}

.info-list li {
  color: #ccc;
  line-height: 1.6;
  margin-bottom: 8px;
  padding-left: 20px;
  position: relative;
}

.info-list li::before {
  content: "🔥";
  position: absolute;
  left: 0;
  top: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-title {
    font-size: 2rem;
  }

  .shader-container {
    padding: 10px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .shader-page {
    padding: 10px;
  }
}
</style>
