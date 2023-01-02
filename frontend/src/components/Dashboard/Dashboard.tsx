import { User, getAuth, signOut } from "firebase/auth";
import React from "react";
import styled from "styled-components";

import { useAuth } from "../../auth/useAuth";
import { Button } from "../Button/Button";
import { breakpoints } from "../theme";
import { TextField } from "../TextField/TextField";

const Page = styled.div`
  @media (max-width: ${breakpoints.sm}) {
    width: 100%;
    border-radius: 0px;
  }
  display: flex;
  gap: 16px;
  flex-direction: column;
  background-color: white;
  width: 500px;
  padding: 24px;
  margin: 0 auto;
  border-radius: 5px;
`;

const cloudFunctionUrl =
  "https://dreambook-request-handler3-rict3hrzrq-ez.a.run.app";

async function submitPrompt(prompt: string, user: User) {
  const token = await user.getIdToken();

  const response = await fetch(cloudFunctionUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      prompt,
    }),
  });

  if (response.status === 200) {
    console.log("Prompt submitted");
  } else {
    console.error("Error submitting prompt");
  }

  return response.json();
}

export const Dashboard: React.FC = () => {
  const { user } = useAuth();

  if (!user) {
    return null;
  }

  const [prompt, setPrompt] = React.useState<string>("");

  return (
    <Page>
      <TextField value={prompt} onChange={(e) => setPrompt(e.target.value)} />
      <Button primary={true} onClick={() => submitPrompt(prompt, user)}>
        Submit prompt
      </Button>
      <Button primary={false} onClick={() => signOut(getAuth())}>
        Sign out
      </Button>
    </Page>
  );
};
