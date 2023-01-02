#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout (location = 0) uniform vec2 size;
layout (location = 1) uniform float numD;

uniform sampler2D img;

out vec4 fragColor;

/**float random(vec3 xyz){
  return fract(sin(dot(xyz, vec3(12.9898, 78.233, 151.7182))) * 43758.5453);
}*/

vec4 square(float numDiv, vec2 position, vec2 size) {
  //size *= .15;

  size.y *= size.x / size.y;
  // rect
  float cellWidth = size.x / numDiv;
  float cellHeight = size.y / numDiv;

  float mX = mod(position.x, cellWidth);
  float mY = mod(position.y, cellHeight);

  float a = position.x - mX;
  float b = position.y - mY;

  float r = cellWidth / 2;

  vec4 c = vec4(vec3(0), 1.);

  vec2 center = vec2(a + r, b + r);

  float onX = step(r, length(vec2(abs(r - mX), abs(r - mY))));
  float onY = step(r, length(vec2(abs(r - mX), abs(r - mY))));

  float on = onX * onY;

  vec4 _ = vec4(0);
  return on < 1 ? texture(img, center / size) : _;
}

// pixelate
void main() {
  vec2 uv = gl_FragCoord.xy / size;

  fragColor = texture(img, uv);

  vec4 colors = vec4(1.);

  float vX = abs(gl_FragCoord.x - size.x / 2);
  float vY = abs(gl_FragCoord.y - size.y / 2);

  float numDiv = length(vec2(vX,vY)) > length(size.xy / 2 )?
  8 :length(vec2(vX,vY)) > length(size.xy / 4 )?
  16 : length(vec2(vX,vY)) > length(size.xy / 8 )?
  32 : length(vec2(vX,vY)) > length(size.xy / 16 )?
  64 : length(vec2(vX,vY)) > length(size.xy / 32 )?
  128 : length(vec2(vX,vY)) > length(size.xy / 64 )?
  256 : length(vec2(vX,vY)) > length(size.xy / 128 )?
  512 : length(vec2(vX,vY)) > length(size.xy / 256 )?
  1024 :length(vec2(vX,vY)) > length(size.xy / 512 )?
  2048 :
  4096  ;
  //float numDiv = (abs(gl_FragCoord.x / size.x / size.x) / abs(gl_FragCoord.y / size.y / size.y)) * numD;
  //float numDiv = (abs(gl_FragCoord.x - size.x/5) / abs(gl_FragCoord.y - size.y/5)  ) * numD;

  colors *= square(numDiv/(11-numD) , gl_FragCoord.xy, size);

  fragColor = colors;
}

