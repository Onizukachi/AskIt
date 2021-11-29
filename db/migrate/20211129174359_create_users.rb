class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      #index нужен чтобы искать по имейлу быстрее и юник гарантирует что в бд не появится двух юзеров с одинановым email
      t.string :email, null: false, index: {unique: true}
      t.string :name
      t.string :password_digest

      t.timestamps
    end
  end
end
