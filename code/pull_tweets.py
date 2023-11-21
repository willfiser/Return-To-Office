import time
import tweepy
import configparser
import pandas as pd

# function for pulling tweets from Twitter API
# Flow of the function goes like this:
# * Loop through all of the keywords
#   * For each of the keywords pull down 250 tweets
#   * Add tweets to appropriate arrays
#   * Exclude the words that we already searched for when the function eventually times out (because of the API limitation)
# * Return keywords
def _pull_tweets(api, keywords, tweets_all, processed_keywords): 
    if len(keywords) > 0:
        try: 
            for idx, keyword in enumerate(keywords):
                print(f'working on {keyword}')
                # pull down tweets
                tweets = tweepy.Cursor(api.search_tweets, q=keyword, lang="en", tweet_mode='extended').items(250)

                # Collect a list of tweets
                tweets_all.extend({'created_at': tweet.created_at, 'text': tweet.full_text, 'keyword': keyword} for tweet in tweets)
                processed_keywords.append(keyword)
        except:
            print(f'last keyword that is processed {processed_keywords[-1]}')
            last_index = keywords.index(processed_keywords[-1])
            keywords = keywords[last_index+1:]

        return keywords, tweets_all, processed_keywords
    else:
        return None, None, None

# setup api keys and secrets that we'll use to authenticate
config = configparser.ConfigParser()
config.read('tweeter_config.ini')

api_key = config['twitter']['api_key']
api_key_secret = config['twitter']['api_key_secret']

access_token = config['twitter']['access_token']
access_token_secret = config['twitter']['access_token_secret']

# perform authentication 
auth = tweepy.OAuthHandler(api_key, api_key_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

# keywords that we'll use to search the twitter API
keywords = ['return-to-work',
'return-to-office',
'work remotely',
'working remotely',
'return to office',
'return to the office',
'days in the office',
'coming into work',
'working onsite',
'productive at work',
'back into the office',
'in-person work',
'remote work',
'remote workers',
'work in-office',
'hybrid work',
'hybrid options']

tweets_all = []
processed_keywords = []

# get first round of tweets
keywords, tweets_all, processed_keywords = _pull_tweets(api, keywords, tweets_all, processed_keywords)

# wait for ~13 mins because of twitter api limitations
time.sleep(800)

# get second round of tweets
keywords, tweets_all, processed_keywords = _pull_tweets(api, keywords, tweets_all, processed_keywords)

# wait for ~13 mins because of twitter api limitations
time.sleep(800)

# getting third round of tweets
keywords, tweets_all, processed_keywords = _pull_tweets(api, keywords, tweets_all, processed_keywords)

# save results to a flat file
final_df = pd.DataFrame(tweets_all)
final_df.to_csv("scraped_tweets.csv")