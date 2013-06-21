class Cohort < ActiveRecord::Base
	has_many :students
  # Remember to create a migration!
end
