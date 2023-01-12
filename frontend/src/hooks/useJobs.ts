import {
  collection,
  FirestoreDataConverter,
  onSnapshot,
  query,
  QueryDocumentSnapshot,
} from "firebase/firestore";
import { useEffect, useState } from "react";

import { useAuth } from "../auth/useAuth";
import { db } from "../firebase";

export const useJobs = () => {
  const { user } = useAuth();
  if (!user) {
    return null;
  }
  const [jobs, setJobs] = useState<Job[] | undefined>();

  const fetchData = async () => {
    const q = query(collection(db, "users", user.uid, "jobs")).withConverter(
      jobConverter
    );

    return onSnapshot(q, (querySnapshot) => {
      const jobs: Job[] = [];
      querySnapshot.forEach((doc) => {
        jobs.push(doc.data());
      });
      setJobs(
        jobs.sort(
          (trn1, trn2) =>
            trn1.creationDate.getTime() - trn2.creationDate.getTime()
        )
      );
    });
  };

  useEffect(() => {
    const unsubscribe = fetchData();
    return () => {
      unsubscribe.then(() => null);
    };
  }, []);

  return jobs;
};

interface JobDto {
  resultUrl: string;
  creationDate: string;
}

interface Job {
  resultUrl: string;
  creationDate: Date;
}

const jobConverter: FirestoreDataConverter<Job> = {
  toFirestore: (trn: Job) => ({
    resultUrl: trn.resultUrl,
    creationDate: trn.creationDate.toISOString(),
  }),
  fromFirestore: (snap: QueryDocumentSnapshot) => {
    const dto: JobDto = snap.data() as JobDto;
    return {
      resultUrl: dto.resultUrl,
      creationDate: new Date(dto.creationDate),
    };
  },
};
