# ![Orientation][orientation-logo]

[![Build Status][ci-image]][ci]
[![Test Coverage][codeclimate-coverage-image]][codeclimate-coverage]
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

### Home

![homepage][homepage]

The home page is composed of the Guides you've created. Everything
you write in Orientation is an article but any article can be marked
as a *Guide*. As soon as you do, the guide article will show up on the
home page. There's absolutely nothing special about guides. It's up to
you to trick them out to make them look like gorgeous guide and connect
them to other articles using a revolutionary technology: the hypertext link.

This is what a lovely guide can look like:
![guide example][guide-example]

### Articles

Since guides are articles, how do articles work? I'm glad you finally
decided to fake interest!

You can browse articles the boring way by going to their index but unless
you're searching for a specific article (which you can also do on the home page)
or you have just a few articles to browse through I wouldn't recommend it.

![article index][article-index]

Why? Well because it's visually overwhelming (if you have a ton of articles) and
I haven't really made the full-text search feature good enough yet to be satisfied
in that regard. But hopefully that will change soon.

#### Creating new articles

Writing a new article is way more exciting:

![writting a new article][writing-article]

You can tell already that I'm not paying attention because despite being prompted
to `Enter an Article Title` I skipped that part and now this screenshot looks silly.
Oh well. Since I haven't found a "rich text formatter" that didn't drive me up
the wall I went with a simple plain text textarea. No weird glitches like that
infuriating Basecamp editor. Of course, if you want to get fancy (for instance
to add useful screenshots) you can use Markdown, we even give you some examples
in the sidebar.

Tags are nothing special. They allow you to connect articles together in a wider
collection than a simple guide would and they also will play a role whenever we
improve search. Typing a tag that doesn't exist gives you the option to create it.

The 'Make this a guide' checkbox is mostly self-explanatory. All it will do is
display this article on the homepage as a guide.

#### Dealing with information rot

By writing and editing a lot of internal documentation for our team (151 to date),
I've found that the likelihood of this information being out of date within six
months approaches infinity. Stuff gets out of date. It's frustrating and it
probably contributes to people never documenting things in the first place.

This is why automatically Orientation will mark articles as `Stale` after six months.
You can configure this with the `STALENESS_LIMIT` inside of the `Article` class
but you should stick with the default for now.

While this feature is disabled for now, for a time we automatically emailed
article authors and editors when an article became stale. Ironically, that got
old quick and people were tired of receiving tons of emails to nag them into
either updating their articles or verifying that they were still fresh. So this
is a work in progress.

It's possible for anyone to mark an article as `Fresh` to confirm that it is.
It's also possible for anyone to mark an article as `Rotten`. That action *will*
notify the contributors of the article (original author and last editor).

### Authors

Intrinsic motivation is the best, so how do we encourage people to write
documentation without treating them like children and offering them candy as a
reward? Well the first step is to recognize their contribution in a reasonable
way. This is in part what the Authors page is for.
![author index][author-index]

But there's an added side-effect. In any organization beyond a certain size it
becomes very difficult to know who is the right person you should ask about
something. There are several possible reasons for that but a few I've honed in on
were:

- you don't know who to ask
- you don't know what they look like

The Authors page allows you to filter people by what I call their `shtick`. Not
their job title, but what they either care about or do. That's because job titles
often fail at their most important job: defining what someone does or is responsible
of. If I'm looking to ask a question to someone from support and I don't know
anyone from that team, all I have to do is type `support`. Et voilà!

![author filtering][author-filtering]

It also comes in handy when by some hilarious miracle your team is full of pairs
of people who share the same first name.

![adams][adams]

### Subscriptions & Endorsements

If you're an avid documentation reader, Orientation gives you two interesting options.

![subscription][subscription]

You can subscribe to an article in case your work depends on the information
within it being up-to-date. That's very useful if you team follows a specific
protocol for something and everyone needs to know when it changes. No more silly
meetings to tell everyone things like that.

![endorsement][endorsement]

You can endorse an article to give it your stamp of approval or simply thank the
article creator for the information provided. It's nice to do, and it feels nice
to be acknowledged. This is not a manipulative reward-system, it's just a way
to make everyone on your team appreciate the effort involved with keeping
information fresh and well-disseminated.

### Authentication

I originally tried to make Orientatio as easy to onboard to as possible for
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
- Weigh endorsed articles higher in search
- Tag merging
- Better tagging management interface
- Track article visits
- Article news feed
- [Article edit log and versioning](https://github.com/olivierlacan/orientation/pull/67)

[ci]: https://magnum.travis-ci.com/olivierlacan/orientation
[ci-image]: https://magnum.travis-ci.com/olivierlacan/orientation.svg?token=bYo3ib4PCJrDSsNRgsEK&branch=master
[gemnasium]: https://gemnasium.com/olivierlacan/orientation
[gemnasium-image]: https://gemnasium.com/f8cac37fbe557103d2ae38bcc8815f40.svg
[codeclimate]: (https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/gpa.svg
[codeclimate-coverage]: https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-coverage-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/coverage.svg

[orientation-logo]: https://github.com/olivierlacan/orientation/blob/master/public/orientation_logo.png
[homepage]: https://cloud.githubusercontent.com/assets/65950/6779965/33a1f756-d161-11e4-9c80-fb8a7d4a2cfc.png
[article-index]: https://cloud.githubusercontent.com/assets/65950/6779981/6d0ef6ce-d161-11e4-91cf-4d497bc032a5.png
[author-index]: https://cloud.githubusercontent.com/assets/65950/6780070/3d29733e-d162-11e4-929e-c693bc0d6de0.png
[author-filtering]: https://cloud.githubusercontent.com/assets/65950/6780115/96e747ca-d162-11e4-8ca7-2ee14dd37ec8.png
[adams]: https://cloud.githubusercontent.com/assets/65950/6780138/c888cf92-d162-11e4-8369-2c0cd88afeb5.png
[writing-article]: https://cloud.githubusercontent.com/assets/65950/6780209/6967596a-d163-11e4-9957-31d78c4cdd4e.png
[guide-example]: https://cloud.githubusercontent.com/assets/65950/6780336/7942d6a6-d164-11e4-9ce5-38af74c67a3c.png
[subscription]: https://cloud.githubusercontent.com/assets/65950/6788416/8e90c2d6-d199-11e4-98f7-4f6779ffc461.png
[endorsement]: https://cloud.githubusercontent.com/assets/65950/6788434/ac043776-d199-11e4-9f6a-8e158cc46ac9.png
