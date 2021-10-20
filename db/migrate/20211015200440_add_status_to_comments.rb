# frozen_string_literal: true

# Add status column to Comments table
class AddStatusToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :status, :string
  end
end
