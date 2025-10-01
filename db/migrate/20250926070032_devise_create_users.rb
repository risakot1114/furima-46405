class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Devise 必須カラム
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## 追加カラム
      t.string :nickname,           null: false
      t.string :first_name,         null: false
      t.string :last_name,          null: false
      t.string :first_name_kana,    null: false
      t.string :last_name_kana,     null: false
      t.date   :birthday,           null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
