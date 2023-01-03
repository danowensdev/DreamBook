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
`;

const AuthForm = styled.form`
  @media (max-width: ${breakpoints.sm}) {
    width: 100%;
    border-radius: 0px;
  }

  -webkit-backdrop-filter: blur(8px);
  backdrop-filter: blur(8px);
  /* Add box-shadow for more depth */
  box-shadow: 0px 10px 15px 10px rgba(0, 0, 0, 0.15);
  background-color: #ff7f8026

  width: 364px;
  padding: 24px;
  margin: 0 auto;
  border-radius: 5px;
  display: grid;
  grid-gap: 16px;
  grid-template-columns: 1fr 1fr;
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
      <Button
        style={{
          gridColumnStart: 1,
          gridColumnEnd: 3,
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
        primary={false}
        onClick={() => signInWithRedirect(getAuth(), googleAuthProvider)}
      >
        <GoogleIcon />
        <span>Continue with Google</span>
        <div style={{ width: "24px" }}></div>
      </Button>
    </AuthForm>
  );
};
