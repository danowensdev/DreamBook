import styled from "styled-components";
import { theme } from "../../theme";

export const Caption = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: center;
  width: 100%;
  color: ${theme.background};
  align-items: center;
  text-align: center;
  min-height: 36px;
  padding: 8px 12px;

  margin: 5px;

  min-width: 40px;
`;
