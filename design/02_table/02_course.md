# Course

## Overview

| Physical Name | Logical Name | Remarks                           |
| ------------- | ------------ | --------------------------------- |
| course        | コース       | Duolingo のコース情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------ |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                |
| COURSE_ID                | コース ID              | -   | -   | ✓   | TEXT    | Duolingo で管理されているコース ID。                   |
| TITLE                    | コース名               | -   | -   | ✓   | TEXT    | Duolingo で管理されているコース名。                    |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。     |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。 |
| XP                       | XP                     | -   | -   | ✓   | INTEGER | Duolingo で管理されている XP。                         |
| CROWNS                   | クラウン数             | -   | -   | ✓   | INTEGER | Duolingo で管理されているクラウン数。                  |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                   |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                   |
