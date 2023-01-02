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


}

// pixelate
void main() {
  vec2 uv = gl_FragCoord.xy / size;

  /**if( numD > 10) {
    fragColor = texture(img, uv-vec2(0,60));
    return;
  }*/

  //fragColor = texture(img, uv);

  vec4 colors = vec4(numD/11);

  float vX = abs(gl_FragCoord.x - size.x / 2);
  float vY = abs(gl_FragCoord.y - size.y / 2);

  float numDiv = length(vec2(vX,vY)) > length(size.xy / 2 )?
  1 * numD:length(vec2(vX,vY)) > length(size.xy / 4 )?
  2 * numD: length(vec2(vX,vY)) > length(size.xy / 8 )?
  4 * numD: length(vec2(vX,vY)) > length(size.xy / 16 )?
  8 * numD: length(vec2(vX,vY)) > length(size.xy / 32 )?
  16 * numD: length(vec2(vX,vY)) > length(size.xy / 64 )?
  32 * numD: length(vec2(vX,vY)) > length(size.xy / 128 )?
  64 * numD: length(vec2(vX,vY)) > length(size.xy / 256 )?
  128 * numD:length(vec2(vX,vY)) > length(size.xy / 512 )?
  256 * numD:
  1024 * numD ;
  //float numDiv = (abs(gl_FragCoord.x / size.x / size.x) / abs(gl_FragCoord.y / size.y / size.y)) * numD;
  //float numDiv = (abs(gl_FragCoord.x - size.x/5) / abs(gl_FragCoord.y - size.y/5)  ) * numD;

  colors *= square(numDiv , gl_FragCoord.xy, size) /*/max(1,abs(11-numD))*/;

  fragColor = colors /*** vec4(vec3(1), .5)*/;
  if( numD > 10) {
    fragColor = texture(img, uv - vec2(0, 63));
    return;
  }

  if( numD > 8) {
    fragColor = min(colors/texture(img, uv - vec2(0, 63)), texture(img, uv-vec2(0,63)) * vec4(vec3(1),numD/10));
  }
  //fragColor = clamp(colors,colors * vec4(2), colors ) /*+ vec4(vec3(0),.3)*/;
}

