#!/usr/bin/python3
"""
This module defines a recursive function to query the Reddit API for all hot posts
in a given subreddit.
"""
import requests

def recurse(subreddit, hot_list=[], after=None):
    """
    Returns a list of titles of all hot posts for a given subreddit.
    If the subreddit is invalid, returns None.
    """
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    headers = {'User-Agent': 'Custom User Agent 1.0'}
    params = {'after': after, 'limit': 100}
    response = requests.get(url, headers=headers, params=params, allow_redirects=False)

    if response.status_code != 200:
        return None

    try:
        data = response.json().get('data', {})
        children = data.get('children', [])
        hot_list.extend([post.get('data', {}).get('title') for post in children])
        after = data.get('after')
        if after is not None:
            return recurse(subreddit, hot_list, after)
        return hot_list
    except Exception:
        return None
