import React from "react";
import styled from "styled-components";
import { LogoHeader } from "../LogoHeader/LogoHeader";

import StarrySkyBackground from "../../assets/starrysky4x.jpeg";
import { breakpoints } from "../theme";
const averageBackgroundImageColor = "#728db8"; // Average color of StarrySkyBackground
const PageContainerDiv = styled.div`
  display: flex;
  align-items: center;
  flex-direction: column;
  margin: 0 auto;
  overflow-y: auto;
  min-width: 300px;
  padding: 24px;
  background-image: url(${StarrySkyBackground});
  background-size: cover;
  background-position: center;
  background-color: ${averageBackgroundImageColor};
  height: 100vh;
  @media (max-width: ${breakpoints.sm}) {
    width: 100%;
    padding: 24px 0px;
  }
`;

const PageDiv = styled.div`
  @media (max-width: ${breakpoints.sm}) {
    width: 100%;
    border-radius: 0px;
  }

  -webkit-backdrop-filter: blur(8px);
  backdrop-filter: blur(8px);
  box-shadow: 0px 10px 15px 10px rgba(0, 0, 0, 0.15);
  background-color: #ff7f8026

  width: 364px;
  padding: 24px;
  margin: 0 auto;
  border-radius: 5px;`;

export const PageContainer: React.FC = ({ children }) => {
  return (
    <PageContainerDiv>
      <LogoHeader />
      <PageDiv>{children}</PageDiv>
    </PageContainerDiv>
  );
};
