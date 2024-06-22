#!/usr/bin/python3
"""
This module defines a function to query the Reddit API for the number of subscribers
in a given subreddit.
"""
import requests

def number_of_subscribers(subreddit):
    """
    Returns the number of subscribers for a given subreddit.
    If the subreddit is invalid, returns 0.
    """
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {'User-Agent': 'Custom User Agent 1.0'}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code != 200:
        return 0
    
    try:
        return response.json().get('data', {}).get('subscribers', 0)
    except Exception:
        return 0
