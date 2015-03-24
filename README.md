# ![Orientation][orientation-logo]

[![Build Status][ci-image]][ci]
[![Test Coverage][codeclimate-coverage-image]][codeclimate-coverage]
[![Code Climate][codeclimate-image]][codeclimate]
[![Dependency Status][gemnasium-image]][gemnasium]

## What is Orientation?

![Orientation's Homepage][orientation-homepage]

See [FEATURES.md](FEATURES.md) for features and benefits.

### Authentication

I originally tried to make Orientation as easy to onboard to as possible for
people in our team. While a huge majority of us had GitHub accounts, not everyone
did. Nor was it realistic to expect non-developers to setup a GitHub account
just to use a documentation tool. We did — however have — company Google Apps
accounts, so this is what I used. I want to enable custom OAuth providers soon.

## Requirements

### Software
- Ruby 2.2.0
- PostgreSQL 9.1
- Python 2.7 (for Pygments)
- Node.js (for Bower)
- Bower

Both Node and Python are available on Heroku if you decide to deploy there,
which means there should not be any issues when deploying or running Orientation
there.

### Services
- AWS S3 bucket for image uploads
- Mandrill account for transactional emails
- Google account for authentication (for now)

## Installation

- `rake orientation:install`
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

## OAuth in development
In development we cheat around OAuth by simply using User.find(1) as the
current user because it's easy and we're lazy. Testing OAuth in dev is
hard.

## Deployment

### Required Environment Variables

See [.env.example](.env.example) file. Note that if you host your Orientation
on Heroku you'll need to set those environment variables manually. I recommend
[dotenv-heroku](https://github.com/sideshowcoder/dotenv-heroku) to do this easily
using you local (git-ignored) `.env` file as a canonical source.

## Goals

- Easy interface to create internal docs & tutorials
- Allow support team to find relevant info quickly
- Keep information up-to-date
- Propagate information through the team
- To be an information base for separate customer-facing documentation

## Features

- Guides (meta-article groups of articles)
- Subscription to articles to receive email updates
- GitHub-style Markdown syntax highlighting & formatting
- Auto-flagging of old articles (> 6 months) as "stale"
- Mark out-of-date articles as "rotten" to notify all contributors (author & editor)
- Mark articles as "fresh" to signal that they are now up-to-date
- Endorse useful or well-written articles (notifies contributors for good feels)
- Article tagging

## Planned Features

- Better search (full-text fuzzy on title/content/tags)
- Weigh endorsed & most visited articles higher in search
- [Article edit log and versioning](https://github.com/olivierlacan/orientation/pull/67)
- Use URL slug versioning to prevent breaking external references

[ci]: https://magnum.travis-ci.com/olivierlacan/orientation
[ci-image]: https://magnum.travis-ci.com/olivierlacan/orientation.svg?token=bYo3ib4PCJrDSsNRgsEK&branch=master
[gemnasium]: https://gemnasium.com/olivierlacan/orientation
[gemnasium-image]: https://gemnasium.com/f8cac37fbe557103d2ae38bcc8815f40.svg
[codeclimate]: (https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/gpa.svg
[codeclimate-coverage]: https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-coverage-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/coverage.svg

[orientation-logo]: https://github.com/olivierlacan/orientation/blob/master/public/orientation_logo.png
[orientation-homepage]: https://cloud.githubusercontent.com/assets/65950/6814712/66cb4684-d281-11e4-800c-329726411b7e.png

## License

Orientation is MIT licensed. See [LICENSE](LICENSE) for details.
