class CreateStudents < ActiveRecord::Migration
  def change
  	create_table :students do |t|
  		t.references :cohort
  		t.string	:name
  		t.string	:picture_url
  		t.timestamps
  	end
  end
end
