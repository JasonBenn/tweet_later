class User < ActiveRecord::Base
  has_many :tweets

  def tweet(status, delay = 0)
    tweet = Tweet.create(tweet_text: status)
    self.tweets << tweet
    TweetWorker.perform_in(delay.seconds, tweet.id)
  end

  def twitter_client
    @twitter_client ||=  Twitter::Client.new(
      :oauth_token => self.oauth_token,
      :oauth_token_secret => self.oauth_secret)
  end
end
