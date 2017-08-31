class TweetsController < ApplicationController
  
  def get_tweet
    ## -------- REFACTOR --------
    ## line 7-17 move to lib/social_media/twitter (internal gem) focused on pulling social media profiles
    ## DONE. see lib/social_media/lib/social_media/twitter/client.rb
    user_handle = params[:user_handle]
    consumer_key = #consumer key
    consumer_secret = #consumer secret key
    access_token = #access token
    access_token_secret = #access secret token
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end

    begin
      
      tweets = client.user_timeline(user_handle, count: 10)
    
      ## -------- REFACTOR --------
      ## WIP: move lives 26-40 to maybe app/helpers? or within lib (internal gem)
      ## doesnt make sense to put this in the model because models should be exclusively an ORM
      # Save user
      user = User.find_by_twitter_name(user_handle)
      if user.blank?
        user = User.create!(twitter_name: user_handle)
      end
      
      # Save tweets
      tweets.each do |tweet|
        if user.tweets.find_by_twitter_id(tweet.id.to_s).blank?
          user.tweets << Tweet.create!(content: tweet.text, twitter_id: tweet.id.to_s)
        end
      end
      
      @tweets = user.tweets.limit(10)
      @error = nil
    rescue Twitter::Error
      @tweets = []
      @error = "Cannot get tweets for #{user_handle}"
    end
  end

  ## -------- REFACTOR --------
  # WIP: use RESTful APIs and leverage saves to user_handle and tweets to db
  def create    
    respond_to do |format|
      format.json { render "create", :status => status_for(get_tweets) }
    end
  end

  def get_tweets
    @client = SocialMedia::Twitter::Client.new(params)
    tweets = @client.get_tweets
  end
end
