module SocialMedia
  class Twitter

    def initialize(params)
      @user_handle = params[:user_handle]
      consumer_key = 'pVOqThEUXzFFRJYlYYx8ijV72'
      consumer_secret = 'DE93IDmRCKbP447C6gwC0FxD89bZjW8CHQSJo3TZbLxVUpUtW9'
      access_token = '2895466123-2WJzU212qonpmj4lrhv11Mjz58tN5noIAm0Dk3A'
      access_token_secret = 'ymwkJngutnRIK9mudVyG5t1F2f2X9QfigwJmQLN3BWrmD'
    end

    def get_tweets
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key
        config.consumer_secret     = consumer_secret
        config.access_token        = access_token
        config.access_token_secret = access_token_secret
      end

      tweets = client.user_timeline(user_handle, count: 10)
    end


  end
end