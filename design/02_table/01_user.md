# User

## Overview

| Physical Name | Logical Name | Remarks                             |
| ------------- | ------------ | ----------------------------------- |
| user          | ユーザー     | Duolingo のユーザー情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------ |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                |
| USER_ID                  | ユーザー ID            | -   | ✓   | ✓   | TEXT    | Duolingo で管理されているユーザー ID。                 |
| USERNAME                 | ログインユーザー名     | -   | -   | ✓   | TEXT    | Duolingo で管理されているログインユーザー名。          |
| NAME                     | 名前                   | -   | -   | ✓   | TEXT    | Duolingo で管理されている名前。                        |
| BIO                      | 略歴                   | -   | -   | ✓   | TEXT    | Duolingo で管理されているプロフィールの略歴。          |
| EMAIL                    | メールアドレス         | -   | -   | ✓   | TEXT    | Duolingo で管理されているメールアドレス。              |
| LOCATION                 | 場所                   | -   | -   | ✓   | TEXT    | Duolingo で管理されている場所。                        |
| PROFILE_COUNTRY          | 国                     | -   | -   | ✓   | TEXT    | Duolingo で管理されている国。                          |
| INVITE_URL               | 招待 URL               | -   | -   | ✓   | TEXT    | Duolingo で管理されている招待 URL。                    |
| CURRENT_COURSE_ID        | 学習中コース ID        | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中のコース ID。           |
| LEARNING_LANGUAGE        | 学習中言語             | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                  |
| FROM_LANGUAGE            | 学習時使用言語         | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。              |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。     |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。 |
| TIMEZONE                 | 時間帯                 | -   | -   | ✓   | TEXT    | Duolingo で管理されている時間帯。                      |
| TIMEZONE_OFFSET          | 時間帯オフセット       | -   | -   | ✓   | TEXT    | Duolingo で管理されている時間帯オフセット。            |
| PICTURE_URL              | プロフィール写真 URL   | -   | -   | ✓   | TEXT    | Duolingo で管理されているプロフィールの写真 URL。      |
| PLUS_STATUS              | 有料会員ステータス     | -   | -   | ✓   | TEXT    | Duolingo で管理されている有料会員ステータス。          |
| LINGOTS                  | リンゴット数           | -   | -   | ✓   | INTEGER | Duolingo で管理されているリンゴット数。                |
| GEMS                     | ジェム数               | -   | -   | ✓   | INTEGER | Duolingo で管理さているジェム数。                      |
| TOTAL_XP                 | 合計 XP                | -   | -   | ✓   | INTEGER | Duolingo で管理されている合計 XP。                     |
| XP_GOAL                  | XP 目標                | -   | -   | ✓   | INTEGER | Duolingo で管理されている XP 目標。                    |
| WEEKLY_XP                | 週別 XP                | -   | -   | ✓   | INTEGER | Duolingo で管理されている週別 XP。                     |
| MONTHLY_XP               | 月別 XP                | -   | -   | ✓   | INTEGER | Duolingo で管理されている月別 XP。                     |
| XP_GOAL_MET_TODAY        | XP 目標到達            | -   | -   | ✓   | INTEGER | Duolingo で管理されている XP 目標到達フラグ。          |
| STREAK                   | ストリーク数           | -   | -   | ✓   | INTEGER | Duolingo で管理されているストリーク数。                |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                   |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                   |
