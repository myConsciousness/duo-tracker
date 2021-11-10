# Purchase History

## Overview

| Physical Name    | Logical Name | Remarks                                                          |
| ---------------- | ------------ | ---------------------------------------------------------------- |
| purchase_history | 購入履歴     | Duo Tracker で行われたアイテムの売買に関する履歴情報を管理する。 |

## Definition

| Physical Name           | Logical Name   | PK  | U   | NN  | Type    | Remarks                            |
| ----------------------- | -------------- | --- | --- | --- | ------- | ---------------------------------- |
| ID                      | ユニーク ID    | ✓   | -   | -   | INTEGER | レコードのユニーク ID。            |
| PRODUCT_NAME            | 商品名         | -   | -   | ✓   | TEXT    | 商品名。                           |
| PRICE                   | 価格           | -   | -   | ✓   | INTEGER | 商品の価格。                       |
| PRICE_TYPE              | 価格種別       | -   | -   | ✓   | INTEGER | 価格の種別。                       |
| VALID_PERIOD_IN_MINUTES | 有効期限（分） | -   | -   | ✓   | INTEGER | 有効期限の分表現。                 |
| PURCHASED_AT            | 購入日時       | -   | -   | ✓   | INTEGER | 商品を購入した日時。               |
| EXPIRED_AT              | 有効期限       | -   | -   | ✓   | INTEGER | 講習した商品の有効期限を示す日時。 |
| CREATED_AT              | 作成日時       | -   | -   | ✓   | INTEGER | レコードの作成日時。               |
| UPDATED_AT              | 更新日時       | -   | -   | ✓   | INTEGER | レコードの更新日時。               |
