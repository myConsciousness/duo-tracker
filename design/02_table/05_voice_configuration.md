# Voice Configuration

## Overview

| Physical Name       | Logical Name | Remarks                                                 |
| ------------------- | ------------ | ------------------------------------------------------- |
| voice_configuration | 音声構成     | Duolingo でサポートされている音声の構成情報を管理する。 |

## Definition

| Physical Name      | Logical Name                | PK  | U   | NN  | Type    | Remarks                                                                             |
| ------------------ | --------------------------- | --- | --- | --- | ------- | ----------------------------------------------------------------------------------- |
| ID                 | ユニーク ID                 | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                                             |
| LEARNING_LANGUAGE  | 学習中言語                  | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                                               |
| FROM_LANGUAGE      | 学習時使用言語              | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。                                           |
| VOICE_TYPE         | 音声タイプ                  | -   | -   | ✓   | TEXT    | Duolingo で管理されている音声タイプ。                                               |
| TTS_BASE_URL_HTTPS | TTS 取得ベース URL（https） | -   | -   | ✓   | TEXT    | Duolingo で管理されている TTS ファイルを https プロトコルで取得する際のベース URL。 |
| TTS_BASE_URL_HTTP  | TTS 取得 ベース URL（http） | -   | -   | ✓   | TEXT    | Duolingo で管理されている TTS ファイルを http プロトコルで取得する際のベース URL。  |
| PATH               | パス                        | -   | -   | ✓   | TEXT    | Duolingo で管理されている TTS ファイルへのパス。                                    |
| CREATED_AT         | 作成日時                    | -   | -   | ✓   | INTEGER | レコードの作成日時。                                                                |
| UPDATED_AT         | 更新日時                    | -   | -   | ✓   | INTEGER | レコードの更新日時。                                                                |
