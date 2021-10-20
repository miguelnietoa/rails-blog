# frozen_string_literal: true

# Add status column to Articles table
class AddStatusToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :status, :string
  end
end
