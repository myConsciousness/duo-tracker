CREATE TABLE TIP_AND_NOTE (
  ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  SKILL_ID TEXT NOT NULL,
  SKILL_NAME TEXT NOT NULL,
  CONTENT TEXT NOT NULL,
  CONTENT_SUMMARY TEXT NOT NULL,
  USER_ID TEXT NOT NULL,
  FROM_LANGUAGE TEXT NOT NULL,
  LEARNING_LANGUAGE TEXT NOT NULL,
  FORMAL_FROM_LANGUAGE TEXT NOT NULL,
  FORMAL_LEARNING_LANGUAGE TEXT NOT NULL,
  SORT_ORDER INTEGER NOT NULL,
  BOOKMARKED TEXT NOT NULL,
  DELETED TEXT NOT NULL,
  CREATED_AT INTEGER NOT NULL,
  UPDATED_AT INTEGER NOT NULL
);
