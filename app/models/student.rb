class Student < ActiveRecord::Base
	has_and_belongs_to_many :groups
  # Remember to create a migration!
end
