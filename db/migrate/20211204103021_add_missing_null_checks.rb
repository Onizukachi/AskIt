class AddMissingNullChecks < ActiveRecord::Migration[6.1]
  def change
    #change_column_nul метод изменяет колонку в таблице questions. false говорим что данная колонка пустой быть не может
    change_column_null :questions, :title, false
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end
