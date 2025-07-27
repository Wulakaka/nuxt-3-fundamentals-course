#version 300 es
precision mediump float;

in vec2 uv;           // UV coordinate passed from vertex shader
out vec4 outColor;    // Final output color

uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;
uniform float uMaskState; // 0-1

// 核心点：
// 通过图片的 r 通道让当前像素的颜色发生位移，以此来区分形状
// 加入鼠标位置实现交互效果

void main() {
  // Flip Y coordinate for texture sampling
  // 如果不翻转，图片会颠倒
  vec2 flippedUV = vec2(uv.x, 1.0f - uv.y);

  // Sample the texture
  float mask = texture(uTexture, flippedUV).r;

  // Animated color using time
  float wave = sin(uTime) * 0.5f + 0.5f;
  vec3 color = vec3(uv.x * wave, uv.y * (1.0f - wave), 0.0f);

  // Mouse circle
  float dist = distance(uv, uMouse);
  // 位移强度 1-0。距离为 0 - 0.5f 时，柔和变化；大于 0.5f 时，为 0
  // 鼠标中心为 1
  float displacementStrength = smoothstep(1.0f, 0.0f, dist * 2.0f);

  vec2 displacement = vec2(sin(mask * 10.0f + uTime) * displacementStrength, cos(mask * 8.0f + uTime * 0.8f) * displacementStrength);
  vec2 displacedUV = uv + displacement * mask;

  // -2 到 2
  // 如果想让背景不随时间发生变化，可以将 uTime 替换为 0.0f
  float gradient = sin(displacedUV.x * 3.0f + uTime) + sin(displacedUV.y * 2.0f + uTime * 0.7f);
  // noise 只是添加一些随机性，范围是 -0.1 到 0.1
  float noise = sin(displacedUV.x * 2.0f) * sin(displacedUV.y * 15.0f) * 0.1f;
  gradient += noise;

  vec3 color1 = vec3(0.2f, 0.4f, 0.8f); // blue
  vec3 color2 = vec3(0.8f, 0.2f, 0.6f); // pink
  vec3 color3 = vec3(0.7f, 0.6f, 0.2f); // yellow

  // -0.5 到 1.5
  // 这里老师说的有误，gradient 的范围是 -2 到 2，不是 -1 到 1
  // 如果要让strength变成 0 到 1 应该改成如下
  // float strength = (gradient + 2.0f) / 4.0f;
  float strength = gradient * 0.5f + 0.5f;
  vec3 gradientColor;

  // color1 和 color3 会出现的概率更高
  if(strength < 0.5f) {
    // alpha -1 到 1
    gradientColor = mix(color1, color2, strength * 2.0f);
  } else {
    // alpha 0 到 2
    gradientColor = mix(color2, color3, (strength - 0.5f) * 2.0f);
  }

  vec3 darkBackgroundColor = vec3(0.1f, 0.1f, 0.12f);

  vec3 normalState = gradientColor;
  // mask 为 0 时，展示 darkBackground
  // 也就是说只在有颜色的区域有效果，此效果放在黑白图片上效果更好
  vec3 maskedState = mix(darkBackgroundColor, gradientColor, mask);

  vec3 finalColor = mix(normalState, maskedState, uMaskState);

  outColor = vec4(finalColor, 1.0f);
}