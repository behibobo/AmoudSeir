class AddDeptToContracts < ActiveRecord::Migration[5.1]
  def change
    add_column :contracts, :dept, :integer, limit: 8
  end
end
