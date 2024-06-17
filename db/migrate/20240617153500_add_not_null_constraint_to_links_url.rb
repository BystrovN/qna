class AddNotNullConstraintToLinksUrl < ActiveRecord::Migration[6.1]
  def change
    change_column_null :links, :url, false
  end
end
