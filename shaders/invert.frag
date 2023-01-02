#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout (location = 0) uniform vec2 size;
uniform sampler2D img;

out vec4 fragColor;

// invert rgb
void main() {
  vec2 uv = gl_FragCoord.xy / size;
  vec4 px = texture(img, uv);
  fragColor = vec4(vec3(1.)-px.rgb, 1.) ;
}