class ChangeCommentsToPolymorphic < ActiveRecord::Migration[7.0]
  def change
    remove_reference :comments, :report, foreign_key: true
    add_reference :comments, :commentable, polymorphic: true, null: false
  end
end
