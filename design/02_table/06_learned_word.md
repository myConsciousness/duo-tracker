# Learned Word

## Overview

| Physical Name | Logical Name | Remarks                                                     |
| ------------- | ------------ | ----------------------------------------------------------- |
| learned_word  | 学習済み単語 | Duolingo でサポートされている学習済みの単語情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                       |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------------- |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                       |
| WORD_ID                  | 単語 ID                | -   | -   | ✓   | TEXT    | Duolingo で管理されている単語 ID。                            |
| USER_ID                  | ユーザー ID            | -   | -   | ✓   | TEXT    | Duolingo で管理されているユーザー ID。                        |
| LEARNING_LANGUAGE        | 学習中言語             | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                         |
| FROM_LANGUAGE            | 学習時使用言語         | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。                     |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。            |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。        |
| STRENGTH_BARS            | 強度                   | -   | -   | -   | INTEGER | Duolingo で管理されている単語の強度。                         |
| INFINITIVE               | 不定詞                 | -   | -   | -   | TEXT    | Duolingo で管理されている単語の不定詞。                       |
| WORD_STRING              | 単語                   | -   | -   | -   | TEXT    | Duolingo で管理されている単語。                               |
| NORMALIZED_STRING        | 正規済み単語           | -   | -   | -   | TEXT    | Duolingo で管理されている正規化された単語。                   |
| POS                      | 品詞                   | -   | -   | -   | TEXT    | Duolingo で管理されている単語の品詞。                         |
| LAST_PRACTICED_MS        | 最終学習日時（ms）     | -   | -   | -   | INTEGER | Duolingo で管理されている単語を最後に学習した日時（ミリ秒）。 |
| SKILL                    | スキル名               | -   | -   | -   | TEXT    | Duolingo で管理されているスキル名。                           |
| SHORT_SKILL              | 短縮スキル名           | -   | -   | -   | TEXT    | Duolingo で管理されている短縮スキル名。                       |
| LAST_PRACTICED           | 最終学習日時           | -   | -   | -   | TEXT    | Duolingo で管理されている単語を最後に学習した日時。           |
| STRENGTH                 | 習熟度                 | -   | -   | -   | REAL    | Duolingo で管理されている単語の習熟度。                       |
| SKILL_URL_TITLE          | URL 上スキル名称       | -   | -   | -   | TEXT    | Duolingo で管理されている URL 上のスキル名称。                |
| GENDER                   | 性別                   | -   | -   | -   | TEXT    | Duolingo で管理されている単語の性別。                         |
| BOOKMARKED               | お気に入り             | -   | -   | ✓   | TEXT    | 単語のお気に入り状態を示すフラグ。                            |
| COMPLETED                | 完了                   | -   | -   | ✓   | TEXT    | 単語の完了状態を示すフラグ。                                  |
| DELETED                  | 削除                   | -   | -   | ✓   | TEXT    | 単語の削除状態を示すフラグ。                                  |
| SORT_ORDER               | 並び順                 | -   | -   | ✓   | INTEGER | 単語の並び順。                                                |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                          |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                          |
