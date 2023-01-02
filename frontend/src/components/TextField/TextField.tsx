import React, { InputHTMLAttributes } from "react";
import styled from "styled-components";
import { theme } from "../theme";

interface TextFieldProps extends InputHTMLAttributes<HTMLInputElement> {}

export const TextField: React.FC<TextFieldProps> = styled.input`
  background-color: #ffffff;
  min-width: 40px;
  padding: 12px;
  font-size: 16px;
  line-height: 1;
  border: 1px solid ${theme.grey};
  &:hover {
    border: 1px solid ${theme.main};
  }
  &:focus {
    border: 1px solid ${theme.main};
    outline: 1px solid ${theme.main};
  }
  border-radius: 5px;
`;

export const Select: React.FC<
  InputHTMLAttributes<HTMLSelectElement>
> = styled.select`
  background-color: #ffffff;
  padding: 12px;
  font-size: 16px;

  line-height: 1;
  border: 1px solid ${theme.grey};
  &:hover {
    border: 1px solid ${theme.main};
  }
  &:focus {
    border: 1px solid ${theme.main};
    outline: 1px solid ${theme.main};
  }
  border-radius: 5px;

  &[type="number"] {
    -moz-appearance: textfield;
  }
`;
