# Orientation

## Purpose

- Easy interface to create internal docs & tutorials
- Allow support team to find relevant info quickly
- Keep information up-to-date
- Propagate information through the team
- To be an information base for separate customer-facing documentation

## Features

### Current

- Write articles in plain text (or Markdown)
- Group articles to make useful onboarding guides
- Subscribe to articles to receive email updates
- Syntax highlight code snippets in multiple languages
- Let Orientation auto-flag old articles (> 6 months) as "stale"
- Manually flag out-of-date articles as "rotten" to notify all contributors (author & editor)
- Manually flag articles as "fresh" to signal that they are now up-to-date
- Endorse useful or well-written articles (notifies contributors for good feels)
- Tag articles for broader categorization and to improve search
- Article URL slug history to prevent 404s when titles change 

### Planned

- Improved search with full-text fuzzy search on title/content/tags and with weighing of endorsed and most visited articles
- [Article versioning](https://github.com/olivierlacan/orientation/pull/67)
- Drag & Drop image uploading (think GitHub Issues) with sane third-party dependencies for asset storage
- Easier setup process (make OAuth optional in production)

## Home

![homepage][homepage]

The home page is composed of the Guides you've created. Everything
you write in Orientation is an article but any article can be marked
as a *Guide*. As soon as you do, the guide article will show up on the
home page. There's absolutely nothing special about guides. It's up to
you to trick them out to make them look like gorgeous guide and connect
them to other articles using a revolutionary technology: the hypertext link.

This is what a lovely guide can look like:
![guide example][guide-example]

## Articles

You can browse articles the boring way by going to their index but unless
you're searching for a specific article (which you can also do on the home page)
or you have just a few articles to browse through I wouldn't recommend it.

![article index][article-index]

Why? Well because it's visually overwhelming (if you have a ton of articles) and
I haven't really made the full-text search feature good enough yet to be satisfied
in that regard. But hopefully that will change soon.

### Creating new articles

![writting a new article][writing-article]

Since I haven't found a "rich text formatter" that didn't drive me up
the wall I went with a simple plain text textarea. No weird glitches like that
infuriating Basecamp editor. Of course, if you want to get fancy (for instance
to add useful screenshots) you can use Markdown, we even give you some examples
in the sidebar.

Tags are nothing special. They allow you to connect articles together in a wider
collection than a simple guide would and they also will play a role whenever we
improve search. Typing a tag that doesn't exist gives you the option to create it.

The 'Make this a guide' checkbox is mostly self-explanatory. All it will do is
display this article on the homepage as a guide.

![Table of Contents][table-of-contents]

All Markdown headings (`#` for heading 1, `##` for heading 2, etc.) you include
in an article will be extracted to create a table of contents. This is especially
useful for long articles that describe an intricate process with multiple parts.

![Anchor Links][anchor-links]

You will also find anchor links on any heading so that you can give someone a link
that will take them directly to the top of the relevant section you meant to share.
A hash symbol appears next to headings to let you know you can use them as links.

### Dealing with information rot

By writing and editing a lot of internal documentation for our team (151 to date),
I've found that the likelihood of this information being out of date within six
months approaches infinity. Stuff gets out of date. It's frustrating and it
probably contributes to people never documenting things in the first place.

This is why Orientation will automatically mark articles as `Stale` after six months.
You can configure this with the `STALENESS_LIMIT` inside of the `Article` class
but you should stick with the default for now.

While this feature is disabled for now, for a time we automatically emailed
article authors and editors when an article became stale. Ironically, that got
old quickly and people were tired of receiving tons of emails to nag them into
either updating their articles or verifying that they were still fresh. So this
is a work in progress.

![Fresh or Rotten?][fresh-rotten]

It's possible for anyone to mark an article as `Fresh` to confirm that it is.
It's also possible for anyone to mark an article as `Rotten`. That action *will*
notify the contributors of the article (original author and last editor).

## Authors

Intrinsic motivation is the best, so how do we encourage people to write
documentation without treating them like children and offering them candy as a
reward? Well the first step is to recognize their contribution in a reasonable
way. This is in part what the Authors page is for.
![author index][author-index]

But there's an added side-effect. In any organization beyond a certain size it
becomes very difficult to know who the right person to ask about something is. 
There are several possible reasons for that but a few I've honed in on
were:

- you don't know who to ask
- you don't know what they look like

The Authors page allows you to filter people by what I call their `shtick`. Not
their job title, but what they either care about or do. That's because job titles
often fail at their most important job: defining what someone does or is responsible
for. If I'm looking to ask a question to someone from support and I don't know
anyone from that team, all I have to do is type `support`. Et voilà!

![author filtering][author-filtering]

It also comes in handy when by some hilarious miracle your team is full of pairs
of people who share the same first name.

![adams][adams]

## Subscriptions & Endorsements

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

[homepage]: https://cloud.githubusercontent.com/assets/65950/6814712/66cb4684-d281-11e4-800c-329726411b7e.png
[article-index]: https://cloud.githubusercontent.com/assets/65950/6779981/6d0ef6ce-d161-11e4-91cf-4d497bc032a5.png
[author-index]: https://cloud.githubusercontent.com/assets/65950/6780070/3d29733e-d162-11e4-929e-c693bc0d6de0.png
[author-filtering]: https://cloud.githubusercontent.com/assets/65950/6780115/96e747ca-d162-11e4-8ca7-2ee14dd37ec8.png
[adams]: https://cloud.githubusercontent.com/assets/65950/6780138/c888cf92-d162-11e4-8369-2c0cd88afeb5.png
[writing-article]: https://cloud.githubusercontent.com/assets/65950/6807643/0190a074-d250-11e4-872e-5dc80bf790ff.png
[guide-example]: https://cloud.githubusercontent.com/assets/65950/6780336/7942d6a6-d164-11e4-9ce5-38af74c67a3c.png
[subscription]: https://cloud.githubusercontent.com/assets/65950/6788416/8e90c2d6-d199-11e4-98f7-4f6779ffc461.png
[endorsement]: https://cloud.githubusercontent.com/assets/65950/6788434/ac043776-d199-11e4-9f6a-8e158cc46ac9.png
[fresh-rotten]: https://cloud.githubusercontent.com/assets/65950/6807673/203e337e-d250-11e4-948f-a7fc20c61f7b.png
[table-of-contents]: https://cloud.githubusercontent.com/assets/65950/6807782/e9544b36-d250-11e4-9d50-f26d77225795.png
[anchor-links]: https://cloud.githubusercontent.com/assets/65950/6807862/615949ba-d251-11e4-9eba-3ccdfe8f3897.png
