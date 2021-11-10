# Duo Tracker Database

## Database

| Physical Name | Logical Name | Remarks                                |
| ------------- | ------------ | -------------------------------------- |
| duo_tracker   | Duo Tracker  | Duo Tracker の永続化データを管理する。 |

## Table

| Physical Name         | Logical Name   | Remarks                                                          |
| --------------------- | -------------- | ---------------------------------------------------------------- |
| user                  | ユーザー       | Duolingo のユーザー情報を管理する。                              |
| course                | コース         | Duolingo で学習中のコース情報を管理する。                        |
| skill                 | スキル         | Duolingo で学習中のスキル情報を管理する。                        |
| supported_language    | サポート言語   | Duolingo でサポートされている言語情報を管理する。                |
| voice_configuration   | 音声構成       | Duolingo でサポートされている音声の構成情報を管理する。          |
| learned_word          | 学習済み単語   | Duolingo で学習した単語情報を管理する。                          |
| word_hint             | 単語ヒント     | Duolingo で学習した単語のヒント情報を管理する。                  |
| purchase_history      | 購入履歴       | Duo Tracker で行われたアイテムの売買に関する履歴情報を管理する。 |
| folder                | フォルダー     | Duo Tracker でのフォルダー情報を管理する。                       |
| folder_item           | フォルダー項目 | Duo Tracker 作成されたフォルダーの項目情報を管理する。           |
| learned_word_sentence | 学習済文章     | Duo Tracker で作成された学習済み単語からなる文章情報を管理する。 |
| tip_and_note          | 補足           | Duolingo で学習した単語やコースに関する補足情報を管理する。      |
