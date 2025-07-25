#version 300 es
precision mediump float;

in vec2 uv;           // UV coordinate passed from vertex shader
out vec4 outColor;    // Final output color

uniform float uTime;
uniform vec2 uMouse;

void main() {
  float wave = sin(uTime) * 0.5f + 0.5f;
  vec3 color = vec3(uv.x * wave, uv.y * (1.0f - wave), 0.0f);

  // Mouse circle
  float dist = distance(uv, uMouse);
  float circle = dist < 0.1f ? 1.0f : 0.0f;

  // Combine base color with circle
  color = mix(color, vec3(1.0f), circle);

  outColor = vec4(color, 1.0f); // RGB from UV, full opacity
}