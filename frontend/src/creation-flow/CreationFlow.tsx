import { User } from "firebase/auth";
import React from "react";
import styled from "styled-components";
import { v4 as uuidv4 } from "uuid";

import { useAuth } from "../auth/useAuth";
import { BookPage } from "../components/BookPage/BookPage";
import { Prompt } from "../components/Prompt/Prompt";
import { config } from "../config";

async function submitPrompt(prompt: string, user: User, request_id: string) {
  const token = await user.getIdToken();

  const response = await fetch(config.cloudFunctionUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      prompt,
      request_id,
    }),
  });

  if (response.status === 201) {
    console.log("Prompt submitted");
  } else {
    console.error("Error submitting prompt");
  }

  return response.json();
}

const FlowPage = styled.div`
  display: flex;
  gap: 16px;
  flex-direction: column;
  align-items: center;
  padding: 24px;
  margin: 0 auto;
  border-radius: 5px;
`;

export const CreationFlow: React.FC = () => {
  const { user } = useAuth();

  if (!user) {
    return null;
  }

  const [prompt, setPrompt] = React.useState<string>("");

  return (
    <FlowPage>
      <BookPage
        pageNumber={1}
        caption={
          "Once upon a time, in a faraway land, there lived a young boy named Ben."
        }
        imageUrl={
          "https://storage.googleapis.com/pai-images/5f11c49f54984d31b9e0bba8e2cd413c.jpeg"
        }
      />
      <Prompt onSubmit={() => submitPrompt(prompt, user, uuidv4())} />
    </FlowPage>
  );
};
