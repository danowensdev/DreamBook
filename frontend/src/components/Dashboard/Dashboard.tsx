import { getAuth, signOut } from "firebase/auth";
import React from "react";
import styled from "styled-components";

import { useAuth } from "../../auth/useAuth";
import { Button } from "../Button/Button";
import { breakpoints } from "../theme";

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

export const Dashboard: React.FC = () => {
  const { user } = useAuth();

  if (!user) {
    return null;
  }

  return (
    <Page>
      <Button primary={false} onClick={() => signOut(getAuth())}>
        Sign out
      </Button>
    </Page>
  );
};
