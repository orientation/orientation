# ![Orientation][orientation-logo]

[![Build Status][ci-image]][ci]
[![Test Coverage][codeclimate-coverage-image]][codeclimate]
[![Code Climate][codeclimate-image]][codeclimate]
[![Dependency Status][gemnasium-image]][gemnasium]
![Ruby Version][ruby-version-image]

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

Here's [how Orientation works](doc/FEATURES.md), you can even
[try it out](http://orientation-demo.herokuapp.com) with your little
fingers.

### Authentication

I originally tried to make Orientation as easy to onboard to as possible for
people in our team. While a huge majority of us had GitHub accounts, not everyone
did. Nor was it realistic to expect non-developers to setup a GitHub account
just to use a documentation tool. By default you can use google as an oauth provider
but also use the one of your choice.

## Requirements

### Software
- Ruby 2.2.0
- PostgreSQL 9.1 (with fuzzystrmatch and pg_trgm extensions)
- Python 2.7 (for Pygments)
- Node.js (for Bower)
- Bower

Both Node and Python are available on Heroku if you decide to deploy there,
which means there should not be any issues when deploying or running Orientation
there.

### Services
- Mandrill account for transactional emails
- Google API project with access to the "Contacts API" and "Google+ API" for OAuth authentication of users.

## Installation

### Heroku
If you want to quickly test out your own Orientation installation, you can use
the Heroku button:

[![Heroku Button][heroku-image]][heroku]

### Docker
See [Docker installation instructions](DOCKER.md).

### Manual Setup
Almost one step: `rake orientation:install`

Make sure to check the [installation task](lib/tasks/orientation.rake) if
anything strange happens during installation.

Once you're done, pay close attention to the `.env` file that will appear at the
root. It's copied from [`.env.example`](.env.example) and contains all the
environment variables needed to configure Orientation.

OAuth is disabled in development and you will be signed in as whichever
user is returned from `User.first`.

## Deployment

### Required Environment Variables

See [.env.example](.env.example) file. Note that if you host your Orientation
on Heroku you'll need to set those environment variables manually. I recommend
[dotenv-heroku](https://github.com/sideshowcoder/dotenv-heroku) to do this easily
using you local (git-ignored) `.env` file as a canonical source.

### Multiple Buildpacks

Multiple buildpack support used to be unofficial and relied on [a custom buildpack created
by David Dollar](https://github.com/ddollar/heroku-buildpack-multi.git). This is no longer
the case since Heroku has rolled out official support for multiple buildpacks.

Therefore, if you decide to deploy Orientation on Heroku manually (without using the Heroku button,
which would take care of this for you) you will need to add two buildpacks since the app relies
on NodeJS for Bower package installation.

Note that for some reason you need to be the owner of the app on Heroku in order to be able to do this:

```shell
heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-ruby -a yourappname
heroku buildpacks:add --index 2 https://github.com/heroku/heroku-buildpack-nodejs -a yourappname
```

When you run the following command, your output should be similar:

```shell
$ heroku buildpacks -a yourappname
=== yourappname Buildpack URLs
1. https://github.com/heroku/heroku-buildpack-nodejs
2. https://github.com/heroku/heroku-buildpack-ruby
```

### Google OAuth 2 setup
- Go to the [Google Developers Console](https://console.developers.google.com/project) and create a new project
- Once you've created the project, go to `APIs` and add the `Contacts API` and the `Google+ API` (you won't need a Google+ account to sign in, this is just an annoying Google quirk).
- Then go to `Credentials` and `Create a new Client ID`. You'll need the app's production URL to complete this step so if you're using the Heroku button, do that first. You can use your production URL for the `JavaScript Origins` setting, but make sure to use `http://yourdomain.com/auth/google_oauth2/callback` for in the `Redirect URIs` setting. It's a good idea to also add the same URL but with the HTTPS protocol to ensure that if you ever force SSL, Google will still accept the redirect.
- Don't forget to go update the `OAUTH_PROVIDER_KEY` and `OAUTH_PROVIDER_SECRET` environment variables with the credentials Google gave you when you created your Client ID, otherwise the redirection process will fail.

### Transactional Emails with Mandrill

If you enable transactional email notifications with Mandrill, you'll need to create Mandrill templates with names
that match the ones listed in our [Mandrill documentation](doc/MANDRILL.md).

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

[ci]: https://travis-ci.org/orientation/orientation
[ci-image]: https://travis-ci.org/orientation/orientation.svg?branch=master
[gemnasium]: https://gemnasium.com/olivierlacan/orientation
[gemnasium-image]: https://gemnasium.com/olivierlacan/orientation.svg
[codeclimate]: https://codeclimate.com/github/olivierlacan/orientation
[codeclimate-image]: https://codeclimate.com/github/olivierlacan/orientation/badges/gpa.svg
[codeclimate-coverage-image]: https://codeclimate.com/github/olivierlacan/orientation/badges/coverage.svg
[heroku]: https://heroku.com/deploy
[heroku-image]: https://www.herokucdn.com/deploy/button.svg
[ruby-version-image]: https://img.shields.io/badge/ruby-2.2.3-brightgreen.svg

[orientation-logo]: https://github.com/olivierlacan/orientation/blob/master/public/orientation_logo.png
[orientation-homepage]: https://cloud.githubusercontent.com/assets/65950/6814712/66cb4684-d281-11e4-800c-329726411b7e.png

## Contributions

We welcome those with open arms but we kindly ask that you [read our contribution guidelines](CONTRIBUTING.md) before submitting pull requests. :heart:

## License

Orientation is MIT licensed. See [LICENSE](LICENSE) for details.
