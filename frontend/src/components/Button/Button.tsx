import styled, { css } from "styled-components";
import { theme } from "../theme";

interface ButtonProps {
  primary: boolean;
}
export const Button = styled.button<ButtonProps>`
  padding: 0.25em 1em;
  height: 46px;
  border-width: 0px;
  &:hover:not(:disabled):not(:active),
  &:focus {
    filter: brightness(1.2);
  }
  &:hover:not(:disabled) {
    cursor: pointer;
  }
  &:active:not(:disabled) {
    filter: brightness(0.9);
  }

  ${(props) =>
    props.primary &&
    css`
      &:disabled {
        background: ${theme.disabled};
      }
      background: ${theme.main};
      color: #222222;
    `};
  ${(props) =>
    !props.primary &&
    css`
      &:disabled {
        border: none;
      }
      border: none;
      background: transparent;
      color: ${theme.main};
    `};
`;

Button.defaultProps = { theme };
