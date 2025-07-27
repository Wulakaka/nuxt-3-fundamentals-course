#version 300 es
precision mediump float;

in vec2 uv;           // 从顶点着色器传入的UV坐标
out vec4 outColor;    // 最终输出颜色

uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;
uniform float uMaskState; // 0-1，控制燃烧强度

// 噪声函数，用于创建自然的燃烧图案
float noise(vec2 p) {
  return fract(sin(dot(p, vec2(12.9898f, 78.233f))) * 43758.5453f);
}

// 分形噪声，用于创建更复杂的图案
float fractalNoise(vec2 p) {
  float value = 0.0f;
  float amplitude = 0.5f;

  for(int i = 0; i < 4; i++) {
    value += amplitude * noise(p);
    p *= 2.0f;
    amplitude *= 0.5f;
  }

  return value;
}

// 平滑噪声函数
float smoothNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);

    // 使用smoothstep实现更平滑的过渡
  f = f * f * (3.0f - 2.0f * f);

  float a = noise(i);
  float b = noise(i + vec2(1.0f, 0.0f));
  float c = noise(i + vec2(0.0f, 1.0f));
  float d = noise(i + vec2(1.0f, 1.0f));

  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
  vec2 flippedUV = vec2(uv.x, 1.0f - uv.y);

    // 采样原始纹理
  vec4 originalTexture = texture(uTexture, flippedUV);

    // 创建动画噪声图案用于燃烧效果
  float timeScale = uTime * 0.5f;
  vec2 noiseCoords = uv * 8.0f;

    // 主要燃烧图案 - 像火焰一样向上移动
  float burnPattern = smoothNoise(noiseCoords + vec2(0.0f, 0.0f));
  burnPattern += smoothNoise(noiseCoords * 2.0f + vec2(sin(timeScale), timeScale * 1.5f)) * 0.5f;
  burnPattern += smoothNoise(noiseCoords * 4.0f + vec2(cos(timeScale * 1.3f), timeScale * 2.0f)) * 0.25f;

    // 基于鼠标位置和时间创建燃烧阈值
  float mouseInfluence = distance(uv, uMouse);
  float burnThreshold = mix(0.3f, 1.2f, uMaskState);

    // 添加鼠标交互 - 燃烧从鼠标位置扩散
  float mouseBurn = 1.0f - smoothstep(0.0f, 0.3f, mouseInfluence);
  burnThreshold -= mouseBurn * 0.5f;

    // 创建燃烧边缘效果
  float burnMask = step(burnThreshold, burnPattern);
  float burnEdge = smoothstep(burnThreshold - 0.03f, burnThreshold + 0.03f, burnPattern);

    // 燃烧效果的颜色调色板
  vec3 paperColor = originalTexture.rgb;
  vec3 charColor = vec3(0.1f, 0.05f, 0.02f);      // 深炭黑色
  vec3 emberColor = vec3(1.0f, 0.3f, 0.0f);       // 明亮橙色
  vec3 fireColor = vec3(1.0f, 0.8f, 0.2f);        // 黄橙火焰色

  // 添加中间炭化色调，使过渡更自然
  vec3 lightCharColor = vec3(0.3f, 0.2f, 0.1f);   // 浅炭色
  vec3 brownedColor = vec3(0.6f, 0.4f, 0.2f);     // 焦糖色

    // 在燃烧边缘创建余烬发光效果
  float ember = smoothstep(0.8f, 1.0f, burnPattern);
  ember *= (1.0f - burnMask) * 0.9f;

    // 动画余烬强度
  float emberPulse = sin(timeScale * 8.0f + uv.x * 10.0f + uv.y * 12.0f) * 0.5f + 0.5f;
  ember *= emberPulse;

    // 基于燃烧阶段混合颜色
  vec3 finalColor = paperColor;

    // 创建更自然的炭化过渡效果
  float charringIntensity = smoothstep(burnThreshold - 0.2f, burnThreshold, burnPattern);
  float deepCharring = smoothstep(burnThreshold - 0.1f, burnThreshold, burnPattern);

  // 添加纹理变化来模拟不均匀的炭化
  float charNoise = smoothNoise(uv * 15.0f + vec2(timeScale * 0.1f));
  charringIntensity *= (0.7f + charNoise * 0.6f);

  // 多阶段颜色过渡：纸张 -> 焦糖色 -> 浅炭色 -> 深炭色
  finalColor = mix(finalColor, brownedColor, charringIntensity * 0.7f);
  finalColor = mix(finalColor, lightCharColor, deepCharring * 0.8f);
  finalColor = mix(finalColor, charColor, burnMask * 0.9f);

    // 在边缘添加余烬发光
  finalColor = mix(finalColor, emberColor, ember);

    // 为活跃燃烧区域添加明亮火焰色
  float activeFire = ember * emberPulse * 3.0f;
  finalColor = mix(finalColor, fireColor, activeFire * 0.8f);

    // 创建烟雾/热浪扭曲效果
  vec2 distortion = vec2(sin(uv.y * 20.0f + timeScale * 3.0f) * 0.01f, cos(uv.x * 15.0f + timeScale * 2.0f) * 0.005f) * burnEdge;

  vec2 distortedUV = flippedUV + distortion;
  vec4 distortedTexture = texture(uTexture, distortedUV);

    // 仅对未燃烧区域应用扭曲
  finalColor = mix(finalColor, distortedTexture.rgb, (1.0f - burnMask) * 0.3f);

    // 计算燃烧区域的透明度（使其透明）
  float alpha = mix(1.0f, 0.1f, burnMask * 0.8f); // 保留一些透明度而不是完全透明
  alpha = max(alpha, ember * 0.8f); // 为余烬发光保留一些透明度

  // 添加炭化区域的轻微透明度变化
  alpha = mix(alpha, 0.7f, charringIntensity * 0.3f);

    // 添加一些大气透视效果
  vec3 atmosphereColor = vec3(0.8f, 0.6f, 0.4f);
  finalColor = mix(finalColor, atmosphereColor, burnMask * 0.2f);

  outColor = vec4(finalColor, alpha);
}
