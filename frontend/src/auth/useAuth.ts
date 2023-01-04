import { User, getAuth } from "firebase/auth";
import { useEffect, useMemo } from "react";
import useLoadingValue from "./useLoadingValue";

export type AuthState = {
  user: User | null | undefined;
  loading: boolean;
  error: Error | undefined;
};

function useAuth() {
  const { error, loading, setError, setValue, value } = useLoadingValue<
    User | null,
    Error
  >(() => getAuth().currentUser);

  const auth = getAuth();

  useEffect(() => {
    const listener = auth.onAuthStateChanged(async (user) => {
      setValue(user);
    }, setError);

    return () => {
      listener();
    };
  }, [auth]);

  const result: AuthState = { user: value, loading, error };
  return useMemo<AuthState>(() => result, [value, loading, error]);
}

export { useAuth };
