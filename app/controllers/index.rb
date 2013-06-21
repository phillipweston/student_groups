get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/create' do
	content_type :json

	Group.create_groups_for_week(params[:cohort_id].to_i, params[:week_number].to_i)
	@groups = Group.display_students(params[:cohort_id].to_i, params[:week_number].to_i)

	redirect "/cohort/#{params[:cohort_id]}/week/#{params[:week_number]}"
end

get '/cohort/:cohort_id/week/:week_number' do
	p @groups = Group.display_students(params[:cohort_id].to_i, params[:week_number].to_i)
	erb :groups
end

get '/cohort/:cohort_id/week/:week_number/delete' do
	Group.delete_group(params[:cohort_id].to_i, params[:week_number].to_i)
	redirect '/'
end


