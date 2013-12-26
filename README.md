# Orientation [![Build Status][ci-image]][ci] [![Dependency Status][gemnasium-image]][gemnasium] [![Coverage Status][codeclimate-image]][codeclimate]

Find your way around Code School support.

## Changelog
http://revision.io/orientation

## Requirements
- Ruby 2.0.0
- PostgreSQL 9.1
- Python 2.7 (for Pygments)

## OAuth in development using Forward
It's impossible to use a non-public domain as an OAuth callback URL for Google OAuth2. To circumvent that, I use Pow locally with the app pointing to orientation.dev and thanks to [Forward](https://forwardhq.com/support/using-forward) (`gem install forward`) I can pretend that the URL `https://orientation-codeschool.fwd.wf` is local by running `forward orientation.dev orientation`.

For this to work automagically you'll need to have he following file at `~/.forward`:

```
---
:api_token: slv9FKz9ipNkpUWJC8XWaEoM
```

## Goals

* Easy interface to create internal docs & tutorials
* Allow support team to find relevant info quickly
* Be used as a base for customer-facing documentation

## Features

* Filtered full-text fuzzy article search
* GitHub-style syntax highlighting & formatting
* Grouping of articles by tags

## Planned Features
* Color-coded & icon tags
* Email notifications when articles are updated (by someone other than you)
* Article edit log
* Categories

[ci]: https://magnum.travis-ci.com/codeschool/orientation
[ci-image]: https://magnum.travis-ci.com/codeschool/orientation.png?token=bYo3ib4PCJrDSsNRgsEK&branch=master
[gemnasium]: https://gemnasium.com/codeschool/orientation
[gemnasium-image]: https://gemnasium.com/f8cac37fbe557103d2ae38bcc8815f40.png
[codeclimate]: (https://codeclimate.com/repos/5158ce6d56b102723b001780/feed
[codeclimate-image]: https://codeclimate.com/repos/5158ce6d56b102723b001780/badges/741c4f4d03a1a9e12804/gpa.png
