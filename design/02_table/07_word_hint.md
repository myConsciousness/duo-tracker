# Word Hint

## Overview

| Physical Name | Logical Name | Remarks                                         |
| ------------- | ------------ | ----------------------------------------------- |
| word_hint     | 単語ヒント   | Duolingo で学習した単語のヒント情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------ |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                |
| WORD_ID                  | 単語 ID                | -   | -   | ✓   | TEXT    | ヒント情報に紐づく単語の外部キー。                     |
| USER_ID                  | ユーザー ID            | -   | -   | ✓   | TEXT    | Duolingo で管理されているユーザー ID。                 |
| LEARNING_LANGUAGE        | 学習中言語             | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                  |
| FROM_LANGUAGE            | 学習時使用言語         | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。              |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。     |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。 |
| VALUE                    | 単語要素               | -   | -   | ✓   | TEXT    | ヒントに紐づく単語要素。                               |
| HINT                     | ヒント                 | -   | -   | ✓   | TEXT    | 単語要素に紐づくヒント。                               |
| SORT_ORDER               | 並び順                 | -   | -   | ✓   | INTEGER | ヒントの並び順。                                       |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                   |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                   |
