class CreateGroupsStudents < ActiveRecord::Migration
  def change
  	create_table :groups_students do |t|
  		t.references :student
  		t.references :group
  	end
  end
end
