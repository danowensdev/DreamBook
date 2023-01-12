import styled from "styled-components";
import { PromptField } from "../Prompt/PromptField";
import { Caption } from "./Caption/Caption";
import { PageImage } from "./Image/Image";

interface BookPageProps {
  pageNumber: number;
  caption: string;
  imageUrl: string;
}
const BookPageDiv = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
`;

export const BookPage: React.FC<BookPageProps> = ({
  pageNumber,
  caption,
  imageUrl,
}) => {
  return (
    <BookPageDiv>
      <PageImage src={imageUrl} />
      <Caption>{caption}</Caption>
    </BookPageDiv>
  );
};
