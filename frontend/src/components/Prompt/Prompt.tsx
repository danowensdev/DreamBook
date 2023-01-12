import styled from "styled-components";
import { PromptField } from "./PromptField";
import { Button } from "../Button/Button";
import React from "react";

const PromptForm = styled.form`
  width: 100%;
  display: flex;
  align-items: center;
  gap: 16px;
`;

interface PromptProps {
  onSubmit: (prompt: string) => void;
}
export const Prompt: React.FC<PromptProps> = ({ onSubmit }) => {
  const [prompt, setPrompt] = React.useState<string>("");

  return (
    <PromptForm
      onSubmit={(e) => {
        e.preventDefault();
      }}
    >
      <PromptField
        value={prompt}
        placeholder="Enter an inspiration..."
        onChange={(e) => setPrompt(e.target.value)}
      />
      <Button primary={true} onClick={() => onSubmit(prompt)}>
        Submit
      </Button>
    </PromptForm>
  );
};
