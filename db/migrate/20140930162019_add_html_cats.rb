class AddHtmlCats < ActiveRecord::Migration
  def change
    add_column :cats, :is_html, :boolean, default: false
  end
end
