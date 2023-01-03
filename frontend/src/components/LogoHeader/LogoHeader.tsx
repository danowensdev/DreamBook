import { theme } from "../theme";
import "./LogoHeader.css";
import styled from "styled-components";

const Header = styled.header`
  font-size: 150px;
  font-family: "Tangerine", cursive;
  color: ${theme.main};
  margin: 24px;
  @media (max-width: 600px) {
    font-size: 25vw;
  }
`;

export const LogoHeader = () => <Header>Dreambook</Header>;
