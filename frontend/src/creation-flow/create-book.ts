import { User } from "firebase/auth";
import { config } from "../config";

export async function createBook(
  prompt: string,
  user: User,
  request_id: string
) {
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

  if (response.status === 200) {
    console.log("Prompt submitted");
  } else {
    console.error("Error submitting prompt");
  }

  return response.json();
}
