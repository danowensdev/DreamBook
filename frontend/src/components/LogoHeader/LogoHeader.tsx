import { breakpoints, theme } from "../theme";
import "./LogoHeader.css";
import styled from "styled-components";

const Header = styled.header`
  font-size: 128px;
  font-family: "Tangerine", cursive;
  color: ${theme.background};
  margin: 24px;
  @media (max-width: ${breakpoints.sm}) {
    font-size: 24vw;
  }
`;

export const LogoHeader = () => <Header>Dreambook</Header>;
