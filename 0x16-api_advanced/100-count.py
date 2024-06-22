#!/usr/bin/python3
"""
This module defines a recursive function to query the Reddit API, parses the title of all hot articles,
and prints a sorted count of given keywords.
"""
import requests
from collections import Counter

def count_words(subreddit, word_list, hot_list=[], after=None):
    """
    Queries the Reddit API, parses the title of all hot articles,
    and prints a sorted count of given keywords (case-insensitive).
    """
    word_list = [word.lower() for word in word_list]
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    headers = {'User-Agent': 'Custom User Agent 1.0'}
    params = {'after': after, 'limit': 100}
    response = requests.get(url, headers=headers, params=params, allow_redirects=False)

    if response.status_code != 200:
        return

    try:
        data = response.json().get('data', {})
        children = data.get('children', [])
        hot_list.extend([post.get('data', {}).get('title', "").lower() for post in children])
        after = data.get('after')
        if after is not None:
            return count_words(subreddit, word_list, hot_list, after)
        
        word_count = Counter()
        for title in hot_list:
            words = title.split()
            for word in words:
                if word in word_list:
                    word_count[word] += 1

        for word, count in sorted(word_count.items(), key=lambda x: (-x[1], x[0])):
            if count > 0:
                print(f"{word}: {count}")
    except Exception:
        return
