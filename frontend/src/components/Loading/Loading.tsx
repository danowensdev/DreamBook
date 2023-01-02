import styled, { keyframes } from "styled-components";
import { ReactComponent as LoadingIcon } from "../../favicon.svg";

const rotation = keyframes`
    0% { transform: rotate(0deg); }
  100% { transform: rotate(359deg); }
`;

export const Loading = () => <div>"Loading..."</div>;
