import styled from "styled-components";

const featherRadiusPx = 30;
const imageSizePx = 400;

export const PageImage = styled.img`
  width: ${imageSizePx}px;
  height: ${imageSizePx}px;
  border-radius: 8px;

  max-width: 100%;
  max-height: 100%;
`;

/*
-webkit-mask-image: linear-gradient(to top, black 0%, black 100%),
linear-gradient(to top, transparent 0%, black 100%),
linear-gradient(to right, transparent 0%, black 100%),
linear-gradient(to bottom, transparent 0%, black 100%),
linear-gradient(to left, transparent 0%, black 100%);
-webkit-mask-position: center, top, right, bottom, left;
-webkit-mask-size: 100% 100%, 100% ${featherRadiusPx}px,
${featherRadiusPx}px 100%, 100% ${featherRadiusPx}px,
${featherRadiusPx}px 100%;
-webkit-mask-repeat: no-repeat, no-repeat, no-repeat, no-repeat, no-repeat;
-webkit-mask-composite: source-out, source-over, source-over, source-over;
mask-image: linear-gradient(to top, black 0%, black 100%),
linear-gradient(to top, transparent 0%, black 100%),
linear-gradient(to right, transparent 0%, black 100%),
linear-gradient(to bottom, transparent 0%, black 100%),
linear-gradient(to left, transparent 0%, black 100%);

mask-position: center, top, right, bottom, left;
mask-size: 100% 100%, 100% ${featherRadiusPx}px, ${featherRadiusPx}px 100%,
100% ${featherRadiusPx}px, ${featherRadiusPx}px 100%;
mask-repeat: no-repeat, no-repeat, no-repeat, no-repeat, no-repeat;
mask-composite: subtract, add, add, add;
*/
