require 'bundler/bouncer'
require File.join(File.dirname(__FILE__),'bootstrap')


helpers do
  
  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    @current_user = session[:user_id] = nil
  end
  
  def logged_in?
    !!current_user
  end
  
  def quick_access?
    :development == settings.environment && 'true' == ENV['QUICK_ACCESS']
  end
  
  def restricted(message, landing_page='/')
    return if logged_in? || quick_access?
    session[:error] = message
    redirect landing_page
  end
  
  def messages
    @messages ||= begin
      hash = Hash.new
      hash[:error] = session.delete :error if session[:error]
      hash
    end
  end
  
  def h(*args)
    ERB::Util.h *args
  end
  
  def without_leading_whitepace(string)
    string.gsub(/^        /,'')
  end
  
  def doing_maintenance?
    'true' == ENV['DOING_MAINTENANCE']
  end
  
end


before do
  @quizzes = [
    Quiz.find_latest(1),
    Quiz.find_latest(2),
    Quiz.find_latest(3),
    Quiz.find_latest(4),
    Quiz.find_latest(5),
  ].compact
end

get '/' do
  haml :home
end

get '/about' do
  @title = 'About Ruby Kickstart'
  haml :about
end
 
  
get '/quizzes/:quiz_number' do
  restricted 'You must be logged in to take quizzes.'
  @quiz = Quiz.find_latest params[:quiz_number]
  @title = @quiz.name
  haml :quiz
end

post '/quizzes/:quiz_number' do  
  restricted 'You must be logged in to submit quizzes'
  quiz = Quiz.find_latest params[:quiz_number]
  quiz_taken = QuizTaken.new :quiz => quiz, :user => current_user
  quiz_taken.apply_solutions params[:quiz_results]
  raise "something went wrong with the quiz submission :/" if quiz_taken.new_record?
  redirect "/quiz_results/#{quiz_taken.id}"
end

get '/quiz_results' do
  restricted 'You must be logged in to view your quizzes.'
  @quiz_takens = current_user.quiz_takens
  @title = 'Quiz Results'
  haml :quizzes
end

get '/quiz_results/:quiz_id' do
  restricted 'You must be logged in to view your results'
  @quiz_taken = QuizTaken.find params[:quiz_id]
  if @quiz_taken.user != current_user
    session[:error] = "You can only view your own quizzes."
    redirect '/quiz_results'
  end
  @title = @quiz_taken.name
  haml :quiz_results
end

get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  user = User.find_by_uid(auth["uid"])
  user ||= User.create  :uid      => auth["uid"], 
                        :provider => params[:name],
                        :name     => auth["user_info"]["name"]
  session[:user_id] = user.id
  redirect '/'
end


%w[/sign_in/? /sign-in/? /signin/? 
   /log_in/?  /log-in/?  /login/?
   /sign_up/? /sign-up/? /signup/?].each do |path|
  get path do
    redirect '/auth/facebook'
  end
end


%w[/sign_out /signout /log_out /logout /log-out /sign-out].each do |path|
  get path do
    session[:user_id] = nil
    redirect '/'
  end
end
