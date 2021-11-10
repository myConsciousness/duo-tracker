# Supported Language

## Overview

| Physical Name      | Logical Name | Remarks                                           |
| ------------------ | ------------ | ------------------------------------------------- |
| supported_language | サポート言語 | Duolingo でサポートされている言語情報を管理する。 |

## Definition

| Physical Name            | Logical Name           | PK  | U   | NN  | Type    | Remarks                                                |
| ------------------------ | ---------------------- | --- | --- | --- | ------- | ------------------------------------------------------ |
| ID                       | ユニーク ID            | ✓   | -   | -   | INTEGER | レコードのユニーク ID。                                |
| LEARNING_LANGUAGE        | 学習中言語             | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習中言語。                  |
| FROM_LANGUAGE            | 学習時使用言語         | -   | -   | ✓   | TEXT    | Duolingo で管理されている学習時使用言語。              |
| FORMAL_LEARNING_LANGUAGE | 学習中言語（正式）     | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習中言語。     |
| FORMAL_FROM_LANGUAGE     | 学習時使用言語（正式） | -   | -   | ✓   | TEXT    | API 通信時に使用される形式に変換された学習時使用言語。 |
| CREATED_AT               | 作成日時               | -   | -   | ✓   | INTEGER | レコードの作成日時。                                   |
| UPDATED_AT               | 更新日時               | -   | -   | ✓   | INTEGER | レコードの更新日時。                                   |
