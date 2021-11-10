# Learned Word Sentence

## Overview

| Physical Name         | Logical Name | Remarks                                                        |
| --------------------- | ------------ | -------------------------------------------------------------- |
| learned_word_sentence | 学習済み文章 | Duo Tracker で作成された学習済み単語からなる文章情報を管理する |

## Definition

| Physical Name | Logical Name | PK  | U   | NN  | Type    | Remarks                                    |
| ------------- | ------------ | --- | --- | --- | ------- | ------------------------------------------ |
| ID            | ユニーク ID  | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                    |
| GROUP_ID      | グループ ID  | -   | -   | ✓   | INTEGER | 文章単位を示すグループ ID。                |
| WORD_ID       | 単語 ID      | -   | -   | ✓   | TEXT    | 文章を構成する単語の外部キー。             |
| USER_ID       | ユーザー ID  | -   | -   | ✓   | TEXT    | Duolingo で管理されているユーザー ID。     |
| DELETED       | 削除         | -   | -   | ✓   | TEXT    | 文章を構成する単語の削除状態を示すフラグ。 |
| CREATED_AT    | 作成日時     | -   | -   | ✓   | INTEGER | レコードの作成日時。                       |
| UPDATED_AT    | 更新日時     | -   | -   | ✓   | INTEGER | レコードの更新日時。                       |
