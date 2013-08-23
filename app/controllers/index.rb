get '/' do
  erb :index
end

post '/tweet' do
  delay = params[:delay].to_i
  job_id = current_user.tweet(params[:tweet_text], delay)
  if request.xhr?
    return job_id
  else
    redirect '/'
  end
end

get '/sign_in' do
  session.clear
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/status/:job_id' do
  content_type :json
  { status: job_is_complete(params[:job_id])}.to_json
end


get '/auth' do
  @access_token = request_token.get_access_token(
    :oauth_verifier => params[:oauth_verifier] )

  session.delete(:request_token)

  @user = User.find_or_create_by_twitter_user_id(
    :screen_name => @access_token.params[:screen_name],
    :twitter_user_id => @access_token.params[:user_id],
    :oauth_token => @access_token.params[:oauth_token],
    :oauth_secret => @access_token.params[:oauth_token_secret] )

  session[:current_user] = @user.id

  erb :index
end
