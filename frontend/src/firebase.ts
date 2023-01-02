import { initializeApp } from 'firebase/app';
import { GoogleAuthProvider } from 'firebase/auth';
import { doc, getFirestore, setDoc } from 'firebase/firestore';

const firebaseApp = initializeApp({
  apiKey: 'AIzaSyBepVWBiahj5q1X8jGGMJ2KqC8ce5HmoGk',
  authDomain: 'dreambook-713.firebaseapp.com',
  projectId: 'dreambook-713',
  storageBucket: 'dreambook-713.appspot.com',
  messagingSenderId: '14923174484',
  appId: '1:14923174484:web:5e6c28eef127ad5d8693c1',
  measurementId: 'G-0P1F1W1L7W'
});
export const db = getFirestore(firebaseApp);

export const googleAuthProvider = new GoogleAuthProvider();
