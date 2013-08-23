class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references  :user
      t.string      :tweet_text
    end
  end
end
