#version 300 es
precision mediump float;

in vec2 uv;           // UV coordinate passed from vertex shader
out vec4 outColor;    // Final output color

uniform float uTime;
uniform vec2 uMouse;
uniform float uCircleSize;
uniform vec3 uCircleColor;
uniform sampler2D uTexture;

void main() {
  // Flip Y coordinate for texture sampling
  vec2 flippedUV = vec2(uv.x, 1.0f - uv.y);

  // Sample the texture
  vec3 textureColor = texture(uTexture, flippedUV).rgb;

  // Animated color using time
  float wave = sin(uTime) * 0.5f + 0.5f;
  vec3 color = vec3(uv.x * wave, uv.y * (1.0f - wave), 0.0f);

  // Mouse circle
  float dist = distance(uv, uMouse);
  float circle = dist < uCircleSize ? 1.0f : 0.0f;

  // Show texture inside circle, colored background outside
  color = mix(uCircleColor, textureColor, circle);

  outColor = vec4(color, 1.0f); // RGB from UV, full opacity
}