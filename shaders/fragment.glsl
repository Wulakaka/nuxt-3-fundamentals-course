#version 300 es
precision mediump float;

in vec2 uv;           // UV coordinate passed from vertex shader
out vec4 outColor;    // Final output color

uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;
uniform float uMaskState;

void main() {
  // Flip Y coordinate for texture sampling
  vec2 flippedUV = vec2(uv.x, 1.0f - uv.y);

  // Sample the texture
  float mask = texture(uTexture, flippedUV).r;

  // Animated color using time
  float wave = sin(uTime) * 0.5f + 0.5f;
  vec3 color = vec3(uv.x * wave, uv.y * (1.0f - wave), 0.0f);

  // Mouse circle
  float dist = distance(uv, uMouse);
  float displacementStrength = smoothstep(1.0f, 0.0f, dist * 2.0f);

  vec2 displacement = vec2(sin(mask * 10.0f + uTime) * displacementStrength, cos(mask * 8.0f + uTime * 0.8f) * displacementStrength);
  vec2 displacedUV = uv + displacement * mask;

  float gradient = sin(displacedUV.x * 3.0f + uTime) + sin(displacedUV.y * 2.0f + uTime * 0.7f);
  float noise = sin(displacedUV.x * 2.0f) * sin(displacedUV.y * 15.0f) * 0.1f;
  gradient += noise;

  vec3 color1 = vec3(0.2f, 0.4f, 0.8f); // blue
  vec3 color2 = vec3(0.8f, 0.2f, 0.6f); // pink
  vec3 color3 = vec3(0.7f, 0.6f, 0.2f); // yellow

  float strength = gradient * 0.5f + 0.5f;
  vec3 gradientColor;

  if(strength < 0.5f) {
    gradientColor = mix(color1, color2, strength * 2.0f);
  } else {
    gradientColor = mix(color2, color3, (strength - 0.5f) * 2.0f);
  }

  vec3 darkBackground = vec3(0.1f, 0.1f, 0.12f);

  vec3 normalState = gradientColor;
  vec3 maskedState = mix(darkBackground, gradientColor, mask);

  vec3 finalColor = mix(normalState, maskedState, uMaskState);

  outColor = vec4(finalColor, 1.0f);
}