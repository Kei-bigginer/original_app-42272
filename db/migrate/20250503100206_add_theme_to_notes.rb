class AddThemeToNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :notes, :theme, :string
  end
end
