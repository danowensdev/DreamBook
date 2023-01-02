import { Navigate, Route, Routes } from "react-router-dom";
import { useAuth } from "../../auth/useAuth";
import { Dashboard } from "../Dashboard/Dashboard";
import { Loading } from "../Loading/Loading";
import { PageContainer } from "../PageContainer/PageContainer";
import { WelcomePage } from "../WelcomePage/WelcomePage";
import "./App.css";
export const App: React.FC = () => {
  const { user, loading } = useAuth();
  const loggedIn = !!user;

  let uiElement: JSX.Element;
  if (loading) {
    uiElement = <Loading />;
  } else if (loggedIn) {
    uiElement = <Dashboard />;
  } else {
    uiElement = <WelcomePage />;
  }
  return (
    <Routes>
      <Route
        path={"/"}
        element={<PageContainer> {uiElement}</PageContainer>}
      ></Route>
      <Route path={"*"} element={<Navigate to={"/"} />} />
    </Routes>
  );
};
