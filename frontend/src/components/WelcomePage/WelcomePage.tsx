import {
  createUserWithEmailAndPassword,
  getAuth,
  signInWithEmailAndPassword,
  signInWithRedirect,
} from "firebase/auth";
import React, { useState } from "react";
import styled from "styled-components";
import { ReactComponent as GoogleLogo } from "../../assets/Google__G__Logo.svg";
import { useAuth } from "../../auth/useAuth";
import { googleAuthProvider } from "../../firebase";
import { Button } from "../Button/Button";
import { TextField } from "../TextField/TextField";
import { breakpoints } from "../theme";

const GoogleIcon = styled(GoogleLogo)`
  background-color: white;
  border-radius: 50%;
  padding: 4px;
  flex-shrink: 0;
`;

const AuthForm = styled.form`
  display: grid;
  grid-gap: 16px;
  grid-template-columns: 1fr 1fr;
`;

const AuthProviderButton = styled(Button)`
  grid-column-start: 1;

  grid-column-end: 3;
  display: flex;
  align-items: center;
  justify-content: space-between;
  @media (max-width: ${breakpoints.sm}) {
    padding: 0px;
  }
`;

export const WelcomePage: React.FC = () => {
  const [email, setEmail] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const { error } = useAuth();

  return (
    <AuthForm noValidate onSubmit={(e) => e.preventDefault()}>
      <TextField
        style={{ gridColumnStart: 1, gridColumnEnd: 3 }}
        placeholder="Email address"
        type="email"
        spellCheck="false"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <TextField
        style={{ gridColumnStart: 1, gridColumnEnd: 3 }}
        placeholder="Password"
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />
      <Button
        primary={true}
        onClick={() => signInWithEmailAndPassword(getAuth(), email, password)}
      >
        Log in
      </Button>
      <Button
        primary={false}
        onClick={() =>
          createUserWithEmailAndPassword(getAuth(), email, password)
        }
      >
        Sign up
      </Button>
      <AuthProviderButton
        primary={false}
        onClick={() => signInWithRedirect(getAuth(), googleAuthProvider)}
      >
        <GoogleIcon />
        <span
          style={{
            padding: "0px 16px",
          }}
        >
          Continue with Google
        </span>
        <div style={{ width: "24px" }}></div>
      </AuthProviderButton>
    </AuthForm>
  );
};
