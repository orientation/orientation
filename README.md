# Orientation [![Build Status][ci-image]][ci] [![Dependency Status][gemnasium-image]][gemnasium] [![Coverage Status][codeclimate-image]][codeclimate]

Find your way around Code School support.

## Requirements
- Ruby 2.0.0
- PostgreSQL 9.1
- Python 2.7 (for Pygments)
- AWS Access Key ID & AWS Secret Access Key for S3 image uploads

## OAuth in development using ngrok
It's impossible to use a non-public domain as an OAuth callback URL for Google OAuth2. To circumvent that, I use Pow locally with the app pointing to orientation.dev and thanks to [ngrok](http://journal.wearebunker.com/post/59684890589/using-ngrok-with-pow-for-development-previews) (`gem install forward`) I can pretend that the URL `http://orientation.ngrok.com` is local by running `ngrok -subdomain=orientation orientation.dev:80`.

## Goals

- Easy interface to create internal docs & tutorials
- Allow support team to find relevant info quickly
- Be used as a base for customer-facing documentation

## Features

- Filtered full-text fuzzy article search
- GitHub-style syntax highlighting & formatting
- Grouping of articles by tags
- Automatic flagging of articles older than 6 months old or not having been updated in 6 months as "stale" with daily batched email notifications to the article author
- Subscription to articles in order to receive email notifications when they're updated by anyone
- Ability to mark articles as "rotten" if out of date and automatically notify all contributors (author & editor)

## Planned Features
- Color-coded & icon tags
- Article edit log
- Categories

[ci]: https://magnum.travis-ci.com/codeschool/orientation
[ci-image]: https://magnum.travis-ci.com/codeschool/orientation.png?token=bYo3ib4PCJrDSsNRgsEK&branch=master
[gemnasium]: https://gemnasium.com/codeschool/orientation
[gemnasium-image]: https://gemnasium.com/f8cac37fbe557103d2ae38bcc8815f40.png
[codeclimate]: (https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/gpa.png
