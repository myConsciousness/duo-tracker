CREATE TABLE WORD_HINT (
  ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  WORD_ID TEXT NOT NULL,
  USER_ID TEXT NOT NULL,
  LEARNING_LANGUAGE TEXT NOT NULL,
  FROM_LANGUAGE TEXT NOT NULL,
  FORMAL_LEARNING_LANGUAGE TEXT NOT NULL,
  FORMAL_FROM_LANGUAGE TEXT NOT NULL,
  VALUE TEXT NOT NULL,
  HINT TEXT NOT NULL,
  SORT_ORDER INTEGER NOT NULL,
  CREATED_AT INTEGER NOT NULL,
  UPDATED_AT INTEGER NOT NULL
);