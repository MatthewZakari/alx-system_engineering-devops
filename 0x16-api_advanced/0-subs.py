#!/usr/bin/python3
"""
Contains the number_of_subscribers function
"""

import requests


def number_of_subscribers(subreddit):
    """Returns the number of subscribers for a given subreddit"""
    if subreddit is None or type(subreddit) is not str:
        return 0
    url = 'https://www.reddit.com/r/{}/about.json'.format(subreddit)
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
    try:
        response = requests.get(url, headers=headers, allow_redirects=False)
        response.raise_for_status()
        json_data = response.json()
        subscribers = json_data.get('data', {}).get('subscribers', 0)
        return subscribers
    except requests.RequestException as e:
        print(f"HTTP Request failed: {e}")
        return 0
    except ValueError as e:
        print(f"Error parsing JSON: {e}")
        return 0

