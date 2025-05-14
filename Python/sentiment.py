import pandas as pd
from sqlalchemy import create_engine
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

nltk.download('vader_lexicon')

def get_data_mysql():

    engine = create_engine("mysql+pymysql://root:jerilalbi@localhost/marketing")

    query = '''SELECT ReviewID, CustomerID, ProductID, ReviewDate,Rating, REPLACE(ReviewText, "  ", " ") as ReviewText FROM customer_reviews ORDER BY 1'''

    df = pd.read_sql(query, engine)
    engine.dispose()

    return df

customer_reviews_df = get_data_mysql()

sia = SentimentIntensityAnalyzer()

def calculate_sentiment(review):
    sentiment = sia.polarity_scores(review)
    return sentiment['compound']

def categorize_sentiment(score,rating):
    if score > 0.05:
        if rating >= 4:
            return 'Positive'
        elif rating == 3:
            return 'Mixed Positive'
        else:
            return 'Mixed Negative'
    elif score < -0.05:
        if rating <= 2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed Negative'
        else:
            return 'Mixed Positive'
    else:
        if rating >= 4:
            return 'Positive'
        elif rating == 3:
            return 'Neutral'
        else:
            return 'Negative'

def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0'
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0'
    else:
        return '-1.0 to -0.5'


customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_sentiment)

customer_reviews_df['SentimentCategory'] = customer_reviews_df.apply(lambda row: categorize_sentiment(row['SentimentScore'], row['Rating']), axis=1)

customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)

customer_reviews_df.to_csv('customer_reviews_with_sentiment.csv', index=False)