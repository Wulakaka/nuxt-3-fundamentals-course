<script setup>
import {onMounted, onUnmounted} from "vue";
import vertexShaderSrc from "../shaders/vertex.glsl?raw";
import fragmentShaderSrc from "../shaders/fragment.glsl?raw";

const props = defineProps({
  maskState: {
    type: Number,
    default: 0.0,
  },
});

const canvas = useTemplateRef("el");
const slotContainer = useTemplateRef("slotContainer");

let gl, program, animationFrame;
let uTimeLocation, uMouseLocation, uMaskStateLocation;

let uTextureLocation, texture;

let mouseX = 0.5,
  mouseY = 0.5;

onMounted(() => {
  gl = canvas.value?.getContext("webgl2");
  if (!gl) {
    console.error("WebGL2 not supported");
    return;
  }

  // Compile and link program
  const vertexShader = compileShader(gl.VERTEX_SHADER, vertexShaderSrc);
  const fragmentShader = compileShader(gl.FRAGMENT_SHADER, fragmentShaderSrc);
  program = linkProgram(vertexShader, fragmentShader);
  gl.useProgram(program);

  // Get uniform locations
  uTimeLocation = gl.getUniformLocation(program, "uTime");
  uMouseLocation = gl.getUniformLocation(program, "uMouse");
  uTextureLocation = gl.getUniformLocation(program, "uTexture");
  uMaskStateLocation = gl.getUniformLocation(program, "uMaskState");

  // Setup triangle index buffer for vertex.glsl
  const indexLoc = gl.getAttribLocation(program, "index");
  const indexBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, indexBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Int32Array([0, 1, 2]), gl.STATIC_DRAW);
  gl.enableVertexAttribArray(indexLoc);
  gl.vertexAttribIPointer(indexLoc, 1, gl.INT, 0, 0);

  // Setup texture from slot content
  setupTexture();

  // Watch the window to resize
  handleResize();
  window.addEventListener("resize", handleResize);

  // Render time!
  const startTime = Date.now();
  const render = () => {
    // Update uniforms
    gl.uniform1f(uTimeLocation, (Date.now() - startTime) / 1000);
    gl.uniform2f(uMouseLocation, mouseX, mouseY);

    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
    animationFrame = requestAnimationFrame(render);
  };

  watch(
    () => props.maskState,
    (newValue) => {
      if (gl && uMaskStateLocation) {
        gl.uniform1f(uMaskStateLocation, newValue);
      }
    },
    {immediate: true}
  );

  render();
});

function setupTexture() {
  const img = slotContainer.value.querySelector("img");
  if (!img) return;

  texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);

  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

  if (img.complete) {
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
  } else {
    img.onload = () => {
      // gl.bindTexture(gl.TEXTURE_2D, texture);
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
    };
  }

  gl.activeTexture(gl.TEXTURE0);
  gl.uniform1i(uTextureLocation, 0);
}

function hexToRgb(hex) {
  const bigint = parseInt(hex.replace("#", ""), 16);
  const r = (bigint >> 16) & 255;
  const g = (bigint >> 8) & 255;
  const b = bigint & 255;
  return [r / 255, g / 255, b / 255];
}

onUnmounted(() => {
  cancelAnimationFrame(animationFrame);
  window.removeEventListener("resize", handleResize);
  if (gl && program) {
    gl.deleteProgram(program);
  }
});

function handleMouseMove(event) {
  const rect = canvas.value.getBoundingClientRect();
  mouseX = (event.clientX - rect.left) / rect.width;
  mouseY = 1.0 - (event.clientY - rect.top) / rect.height; // Flip Y
}

function handleResize() {
  const canvasEl = canvas.value;
  const dpr = window.devicePixelRatio || 1;
  canvasEl.width = canvasEl.clientWidth * dpr;
  canvasEl.height = canvasEl.clientHeight * dpr;
  gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
}

function compileShader(type, source) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error(gl.getShaderInfoLog(shader));
    return null;
  }
  return shader;
}

function linkProgram(vertexShader, fragmentShader) {
  const program = gl.createProgram();
  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);
  gl.linkProgram(program);
  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error(gl.getProgramInfoLog(program));
    return null;
  }
  return program;
}
</script>

<template>
  <div>
    <div ref="slotContainer" style="display: none">
      <slot />
    </div>
    <canvas ref="el" @mousemove="handleMouseMove" />
  </div>
</template>

<style scoped>
canvas {
  display: block;
  width: 60%;
  aspect-ratio: 3/2;
}
</style>
