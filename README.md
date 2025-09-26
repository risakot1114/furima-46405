
## Users テーブル
| Column          | Type   | Options                 |
|-----------------|--------|-------------------------|
| nickname        | string | null: false             |
| email           | string | null: false, unique: true|
| password        | string | null: false             |
| first_name      | string | null: false             |
| last_name       | string | null: false             |
| first_name_kana | string | null: false             |
| last_name_kana  | string | null: false             |
| birthday        | date   | null: false             |

- has_many :items  
- has_many :orders  

---

### Items テーブル
| Column          | Type       | Options                        |
|-----------------|------------|--------------------------------|
| image           | string     | null: false                    |
| name            | string     | null: false                    |
| description     | text       | null: false                    |
| category        | string     | null: false                    |
| condition       | string     | null: false                    |
| shipping_fee    | string     | null: false                    |
| shipping_origin | string     | null: false                    |
| days_to_ship    | string     | null: false                    |
| price           | integer    | null: false                    |
| commission      | integer    |                                |
| profit          | integer    |                                |
| user            | references | null: false, foreign_key: true |

- belongs_to :user  
- has_one :order  

---

### Orders テーブル
| Column    | Type       | Options                        |
|-----------|------------|--------------------------------|
| credit    | string     | null: false                    |
| item      | references | null: false, foreign_key: true |
| user      | references | null: false, foreign_key: true |

- belongs_to :user  
- belongs_to :item  
- has_one :address  

---

### Addresses テーブル
| Column       | Type       | Options                        |
|--------------|------------|--------------------------------|
| postal_code  | string     | null: false                    |
| prefecture   | string     | null: false                    |
| city         | string     | null: false                    |
| address      | string     | null: false                    |
| building_name| string     |                                |
| phone_number | string     | null: false                    |
| order        | references | null: false, foreign_key: true |

- belongs_to :order  