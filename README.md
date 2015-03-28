# ![Orientation][orientation-logo]

[![Build Status][ci-image]][ci]
[![Test Coverage][codeclimate-coverage-image]][codeclimate]
[![Code Climate][codeclimate-image]][codeclimate]
[![Dependency Status][gemnasium-image]][gemnasium]

## What is Orientation?

Documentation is hard. People forget to write it, and they are asked the
same question over and over again. When they finally do write it down,
people can't find it or it gets out of date before it can be useful.

The goal of Orientation was to make a single point of entry for any
internal question someone might have about our organization:

> How can I help with bugs, maintenance and other issues?

> Do we give student discounts?

> How can I help on support?

![Orientation's Homepage][orientation-homepage]

Here's [how Orientation works](doc/FEATURES.md).

### Authentication

I originally tried to make Orientation as easy to onboard to as possible for
people in our team. While a huge majority of us had GitHub accounts, not everyone
did. Nor was it realistic to expect non-developers to setup a GitHub account
just to use a documentation tool. We did — however have — company Google Apps
accounts, so this is what I used. I want to enable custom OAuth providers soon.

## Requirements

### Software
- Ruby 2.2.0
- PostgreSQL 9.1 (with fuzzystrmatch and pg_trgm extensions)
- imagemagick (brew install imagemagick)
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

Almost one step: `rake orientation:install`

Make sure to check the [installation task](lib/tasks/orientation.rake) if
anything strange happens during installation.

Once you're done, pay close attention to the `.env` file that will appear at the
root. It's copied from [`.env.example`](.env.example) and contains all the
environment variables needed to configure Orientation.

Since setting up S3 is a bit tedious, avatar uploads use local file storage in development.
Likewise, OAuth is disabled in development and you will be signed in as whichever
user is returned from `User.first`.

## Deployment

### Required Environment Variables

See [.env.example](.env.example) file. Note that if you host your Orientation
on Heroku you'll need to set those environment variables manually. I recommend
[dotenv-heroku](https://github.com/sideshowcoder/dotenv-heroku) to do this easily
using you local (git-ignored) `.env` file as a canonical source.

## Development

### Styling

Orientation uses a Sass-based CSS architecture called [MVCSS](http://mvcss.io/).
It was extracted from [Envy](http://madewithenvy.com) and [Code School](http//codeschool.com)
work by both front-end teams.

It's not nearly as complex as a framework. The basic gist is that we try to
keep things as modular and dynamic as possible. Magic values are not welcome.
If you contribute styling changes to Orientation, please take the time to get
the lay of the land.

### OAuth in development
In development we cheat around OAuth by simply using `User.first` as the
current user because it's easy and we're lazy. Testing OAuth in dev is
hard.

If you're curious what the OmniAuth hash from Google OAuth 2 looks like [check
this out](doc/OAUTH.md).

[ci]: https://travis-ci.org/olivierlacan/orientation
[ci-image]: https://travis-ci.org/olivierlacan/orientation.svg?branch=master
[gemnasium]: https://gemnasium.com/olivierlacan/orientation
[gemnasium-image]: https://gemnasium.com/olivierlacan/orientation.svg
[codeclimate]: https://codeclimate.com/github/olivierlacan/orientation
[codeclimate-image]: https://codeclimate.com/github/olivierlacan/orientation/badges/gpa.svg
[codeclimate-coverage-image]: https://codeclimate.com/github/olivierlacan/orientation/badges/coverage.svg

[orientation-logo]: https://github.com/olivierlacan/orientation/blob/master/public/orientation_logo.png
[orientation-homepage]: https://cloud.githubusercontent.com/assets/65950/6814712/66cb4684-d281-11e4-800c-329726411b7e.png

## License

Orientation is MIT licensed. See [LICENSE](LICENSE) for details.
