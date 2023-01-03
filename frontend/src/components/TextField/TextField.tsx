import React, { InputHTMLAttributes } from "react";
import styled from "styled-components";
import { theme } from "../theme";

interface TextFieldProps extends InputHTMLAttributes<HTMLInputElement> {}

export const TextField: React.FC<TextFieldProps> = styled.input`
  background-color: transparent;
  min-width: 40px;
  color: ${theme.main};

  ::placeholder {
    color: ${theme.main};
    opacity: 0.7; /* Firefox */
  }
  padding: 12px;
  line-height: 1;
  border: none;
  &&:hover {
    border: none;
    outline: none;
  }
  &&:focus {
    border: none;
    outline: none;
  }
  &&&:focus-visible {
    border: none;
    outline: none;
  }
`;
