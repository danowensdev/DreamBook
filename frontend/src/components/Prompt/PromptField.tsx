import styled from "styled-components";
import { theme } from "../theme";

export const PromptField = styled.input`
  display: flex;
  flex-direction: row;
  align-items: center;
  min-height: 36px;
  padding: 8px 12px;

  background: ${theme.background};
  box-shadow: 0px 0px 4px 4px ${theme.background};
  border-radius: 5px;
  margin: 5px;
  width: 100%;

  min-width: 40px;
  color: ${theme.text};

  ::placeholder {
    color: ${theme.secondary};
    opacity: 0.7; /* Firefox */
  }

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
