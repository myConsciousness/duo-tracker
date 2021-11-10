# Folder

## Overview

| Physical Name | Logical Name | Remarks                                    |
| ------------- | ------------ | ------------------------------------------ |
| folder        | フォルダー   | Duo Tracker でのフォルダー情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------ |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                |
| PARENT_FOLDER_ID         | 親フォルダー ID        | -   | -   | ✓   | INTEGER | 入れ子になった場合の親フォルダーの ID。                |
| FOLDER_TYPE              | フォルダー種別         | -   | -   | ✓   | INTEGER | フォルダーの種別を示す定数値。                         |
| NAME                     | 名称                   | -   | -   | ✓   | TEXT    | フォルダーの名称。                                     |
| REMARKS                  | 備考                   | -   | -   | ✓   | TEXT    | フォルダーの備考。                                     |
| USER_ID                  | ユーザー ID            | -   | -   | ✓   | TEXT    | Duolingo で管理されているユーザー ID。                 |
| LEARNING_LANGUAGE        | 学習中言語             | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                  |
| FROM_LANGUAGE            | 学習時使用言語         | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。              |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。     |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。 |
| SORT_ORDER               | 並び順                 | -   | -   | ✓   | INTEGER | フォルダーの並び順。                                   |
| DELETED                  | 削除                   | -   | -   | ✓   | TEXT    | フォルダーの削除状態を示すフラグ。                     |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                   |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                   |
