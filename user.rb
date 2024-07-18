class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects
  has_and_belongs_to_many :projects_as_member, class_name: 'Project', join_table: 'projects_users'

  def admin?
    self.admin
  end
end
