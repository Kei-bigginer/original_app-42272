class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      # 投稿者のユーザーID（外部キー制約あり、必須）
      t.references :user, null: false, foreign_key: true

      # 投稿内容（140文字以内、空NG）
      t.text :content, null: false, limit: 140
 
      t.timestamps
    end
  end
end
