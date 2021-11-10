# Skill

## Overview

| Physical Name | Logical Name | Remarks                           |
| ------------- | ------------ | --------------------------------- |
| skill         | スキル       | Duolingo のスキル情報を管理する。 |

## Definition

| Physical Name       | Logical Name   | PK  | U   | NN  | Type         | Remarks                                                 |
| ------------------- | -------------- | --- | --- | --- | ------------ | ------------------------------------------------------- |
| ID                  | ユニーク ID    | ✓   | -   | -   | INTEGER      | レコードのユニーク ID。                                 |
| SKILL_ID            | スキル ID      | -   | -   | ✓   | TEXT         | Duolingo で管理されているスキル ID。                    |
| NAME                | スキル名       | -   | -   | ✓   | TEXT         | Duolingo で管理されているスキル名。                     |
| SHORT_NAME          | 短縮スキル名   | -   | -   | ✓   | TEXT         | Duolingo で管理されている短縮されたスキル名。           |
| URL_NAME            | URL 上名称     | -   | -   | ✓   | TEXT         | Duolingo で管理されている URL 名称。                    |
| ACCESSIBLE          | アクセス可能   | -   | -   | ✓   | INTEGER TEXT | Duolingo で管理されているスキル情報へのアクス権限。     |
| ICON_ID             | アイコン ID    | -   | -   | ✓   | INTEGER      | Duolingo で管理されているアイコン ID。                  |
| LESSONS             | レッスン数     | -   | -   | ✓   | INTEGER      | Duolingo で管理されているレッスン数。                   |
| STRENGTH            | レッスン習熟度 | -   | -   | ✓   | REAL         | Duolingo で管理されているレッスン習熟度。               |
| LAST_LESSON_PERFECT | 全問正解       | -   | -   | ✓   | TEXT         | Duolingo で管理されている前回レッスンの全問正解フラグ。 |
| FINISHED_LEVELS     | 終了レベル     | -   | -   | ✓   | INTEGER      | Duolingo で管理されているレッスンの終了レベル。         |
| LEVELS              | レベル         | -   | -   | ✓   | INTEGER      | Duolingo で管理されているレッスンのレベル。             |
| TIP_AND_NOTE_ID     | 補足 ID        | -   | -   | ✓   | INTEGER      | レコードのスキルに紐づく補足情報への外部キー。          |
| CREATED_AT          | 作成日時       | -   | -   | ✓   | INTEGER      | レコードの作成日時。                                    |
| UPDATED_AT          | 更新日時       | -   | -   | ✓   | INTEGER      | レコードの更新日時。                                    |
