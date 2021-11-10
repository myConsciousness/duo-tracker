# Tip And Note

## Overview

| Physical Name | Logical Name | Remarks                                                     |
| ------------- | ------------ | ----------------------------------------------------------- |
| tip_and_note  | 補足         | Duolingo で学習した単語やコースに関する補足情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------ |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                |
| SKILL_ID                 | スキル ID              | -   | -   | ✓   | TEXT    | Duolingo で管理されているスキル ID。                   |
| SKILL_NAME               | スキル名               | -   | -   | ✓   | TEXT    | Duolingo で管理されているスキル名。                    |
| CONTENT                  | 内容                   | -   | -   | ✓   | TEXT    | Duplingo で管理されている補足の内容。                  |
| CONTENT_SUMMARY          | 内容（要約）           | -   | -   | ✓   | TEXT    | 内容の要約。(100 文字)                                 |
| USER_ID                  | ユーザー ID            | -   | -   | ✓   | TEXT    | Duolingo で管理されているユーザー ID。                 |
| LEARNING_LANGUAGE        | 学習中言語             | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                  |
| FROM_LANGUAGE            | 学習時使用言語         | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。              |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。     |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。 |
| SORT_ORDER               | 並び順                 | -   | -   | ✓   | INTEGER | 項目の並び順。                                         |
| BOOKMARKED               | お気に入り             | -   | -   | ✓   | TEXT    | 補足のお気に入り状態を示すフラグ。                     |
| DELETED                  | 削除                   | -   | -   | ✓   | TEXT    | 補足の削除状態を示すフラグ。                           |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                   |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                   |
