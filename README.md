# Orientation
[![Build Status][ci-image]][ci]
[![Test Coverage][codeclimate-coverage-image]][codeclimate-coverage]
[![Code Climate][codeclimate-image]][codeclimate]
[![Dependency Status][gemnasium-image]][gemnasium]

Find your way around Code School support.

## Requirements
- Ruby 2.1.0
- PostgreSQL 9.1
- Python 2.7 (for Pygments)
- AWS Access Key ID & AWS Secret Access Key for S3 image uploads

## Installation

- `bundle install`
- `cp config/database.example.yml config/database.yml`
- Configure `config/database.yml` with your local Postgres credential (usually `username: root` and no `password`)
- rake db:create
- rake db:setup
- In the Rails console (`rails c`), enter the command `User.create(email: 'test@codeschool.com')`
- gem install powder
- powder link
- powder open

Be aware that you don't have the necessary environment variables to use uploading
features like the avatar upload, and that you won't be able to use authentication
either, but you will be logged in as the first user in the database in development.

## Seeding Development Environment with Production data
- use pgbackups

If you want to see avatars in development, you will need to create a file called `.env` in your root folder.

Inside of the file, you should put the following:

```
S3_BUCKET=codeschool
```

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
- Tag merging
- Better tagging management interface
- Track article visits
- Let people say "this was useful"
- Article news feed
- Eventually weigh the useful articles higher in search
- Color-coded & icon tags
- Authors page leaderboard sorting
- Article edit log
- Categories

[ci]: https://magnum.travis-ci.com/codeschool/orientation
[ci-image]: https://magnum.travis-ci.com/codeschool/orientation.svg?token=bYo3ib4PCJrDSsNRgsEK&branch=master
[gemnasium]: https://gemnasium.com/codeschool/orientation
[gemnasium-image]: https://gemnasium.com/f8cac37fbe557103d2ae38bcc8815f40.png
[codeclimate]: (https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/gpa.png
[codeclimate-coverage]: https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-coverage-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/coverage.png
