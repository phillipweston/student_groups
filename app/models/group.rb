class Group < ActiveRecord::Base
	has_and_belongs_to_many :students

	def self.create_groups_for_week(cohort_id, week_number)
		Group.create_first_group(cohort_id) if week_number == 1
		Group.create_subsequent_group(cohort_id, week_number) if week_number > 1
	end

	def self.create_first_group(cohort_id)
		cohort = Cohort.find(cohort_id).name
		cohort_students = Student.find_all_by_cohort_id(cohort_id).shuffle!

		num_groups = (cohort_students.length / 4) + 1
		num_groups -= 1 if cohort_students.length % 4 == 0

		num_groups.times do |i|
			group = Group.create(name: "#{cohort} Week 1 Group #{i+1}")
			group.students << cohort_students.shift(4)
		end
	end

	def self.create_subsequent_group(cohort_id, week_number)
		cohort = Cohort.find(cohort_id).name
		cohort_students = Student.find_all_by_cohort_id(cohort_id).shuffle!
		num_groups = (cohort_students.length / 4) + 1
		num_groups -= 1 if cohort_students.length % 4 == 0

		num_groups.times do |i|
			group = Group.create(name: "#{cohort} Week #{week_number} Group #{i+1}")
			group.students << cohort_students.shift
			previous_teammates = []

			3.times do

				group.students.each do |current_student|
					current_student.groups.each do |group|
						previous_teammates += group.students
					end
				end

				if cohort_students.length < 4
					group.students << cohort_students.shift
					break
				end

				have_not_grouped_with = (cohort_students - previous_teammates).shuffle!
				group.students << have_not_grouped_with.shift
				cohort_students -= group.students
			end
		end
		self.display_students(cohort_id, week_number)
	end

	def self.display_students(cohort_id, week_number)
		cohort = Cohort.find(cohort_id).name
		groups = Group.where('name like ? and name like ?', "%#{cohort}%", "%Week #{week_number}%")
		group_output = {}

		groups.each do |group|
			students = []
			group.students.each do |student|
				students << { name: student.name, picture: student.picture_url }
			end
			group_output[group.name] = students
		end
		group_output
	end

	def self.delete_group(cohort_id, week_number)
		cohort = Cohort.find(cohort_id).name
		groups = Group.where('name like ? and name like ?', "%#{cohort}%", "%Week #{week_number}%")
		groups.each do |group|
			group.delete
		end
	end

end