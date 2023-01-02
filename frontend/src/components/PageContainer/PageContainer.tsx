import React from "react";
import styled from "styled-components";
import { LogoHeader } from "../LogoHeader/LogoHeader";

const PageContainerDiv = styled.div`
  display: flex;
  align-items: center;
  flex-direction: column;
  margin: 0 auto;
  overflow-y: auto;
  min-width: 300px;
  padding: 24px;
  background-color: #eeffee;
  height: 100vh;
  @media (max-width: 600px) {
    width: 100%;
    padding: 24px 0px;
  }
`;

export const PageContainer: React.FC = ({ children }) => {
  return (
    <PageContainerDiv>
      <LogoHeader />
      {children}
    </PageContainerDiv>
  );
};