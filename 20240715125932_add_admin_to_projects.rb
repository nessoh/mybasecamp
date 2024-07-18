class AddAdminToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :admin, :boolean, default: false
  end
end

