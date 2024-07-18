class Project < ApplicationRecord
        belongs_to :user
        has_and_belongs_to_many :members, class_name: 'User', join_table: 'projects_users'
      
        def set_admin(user)
          user.update(admin: true)
        end
      
        def remove_admin(user)
          user.update(admin: false)
        end
      end
      