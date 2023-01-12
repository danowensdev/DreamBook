import { Navigate, Route, Routes } from "react-router-dom";
import { useAuth } from "./auth/useAuth";
import { CreationFlow } from "./creation-flow/CreationFlow";
import { Loading } from "./components/Loading/Loading";
import { PageContainer } from "./components/PageContainer/PageContainer";
import { AuthPage } from "./auth/AuthPage";
import "./App.css";
export const App: React.FC = () => {
  const { user, loading } = useAuth();
  const loggedIn = !!user;

  let uiElement: JSX.Element;
  if (loading) {
    uiElement = <Loading />;
  } else if (loggedIn) {
    uiElement = <CreationFlow />;
  } else {
    uiElement = <AuthPage />;
  }
  return (
    <Routes>
      <Route
        path={"/"}
        element={
          <PageContainer loggedIn={loggedIn}> {uiElement}</PageContainer>
        }
      ></Route>
      <Route path={"*"} element={<Navigate to={"/"} />} />
    </Routes>
  );
};
