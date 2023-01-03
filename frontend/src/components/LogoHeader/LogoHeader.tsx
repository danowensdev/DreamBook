import { theme } from "../theme";
import "./LogoHeader.css";
import styled from "styled-components";

const Header = styled.header`
  font-size: 150px;
  font-family: "Tangerine", cursive;
  color: ${theme.main};
  margin: 24px;
`;

export const LogoHeader = () => <Header>Dreambook</Header>;
