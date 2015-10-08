# News
Interesting new features added to this project will be documented here reverse chronologically.
This is [not a change log](CHANGELOG.md).

## October 4th, 2015
### Email privacy

I noticed a few weeks ago that private emails from people trying out try.orientation.io were being displayed. That was problematic because people testing out the site didn't agree to have their email shared. So I added a new option that can be triggered with `user.update(private_email: true)`. It's stored inside of a native Postgres JSON column called `preferences` to which we'll eventually add more user-specific settings (without need for new columns).

There's also a `rake make_all_emails_private` which can run this command for all existing users. I will not be making private emails a default for now but will likely add a new Orientation configuration option to have email privacy be a default or not so that public-facing Orientation installations don't leak private email information from people authenticating with their private Gmail accounts.

## September 22nd, 2015
### Rot reporter logging and more human emails

![Rotten Banner displaying the name of the rot reporter and the date at which it was marked as rotten](https://s3.amazonaws.com/f.cl.ly/items/103F280238162B1N3r0H/Screen%20Shot%202015-09-22%20at%206.59.51%20PM.png)

Whenever someone reported an article as rotten, there used to be no way to know who that person was. Now rot reporter is logged and when the contributors to the article are notified, they are told who reported the rot. Here's why:

- it makes things more human, it's not just a game of whack-a-mole to find articles and mark them as rotten
- it allows for conversations to happen between the reporter and the article contributors
- if notifications are turned off it allows a reader or contributor of the article to reach out to the rot reporter in order to refresh the article

This update requires a manual update to your Mandrill templates for [`Article Endorsement Notification`](https://github.com/orientation/orientation/blob/master/doc/MANDRILL.md#article-rotten-update) and `Article Rotten Update`](https://github.com/orientation/orientation/blob/master/doc/MANDRILL.md#article-rotten-update)

## September 21st, 2015
### Contribution guidelines and code of conduct

It took me way too long to add these to the project but I'm glad they're finally there. Please take a look at them if you plan to contribute to Orientation at any point:

- [Contribution Guidelines](https://github.com/orientation/orientation/blob/master/CONTRIBUTING.md)
- [Code of Conduct](https://github.com/orientation/orientation/blob/master/CODE_OF_CONDUCT.md)

## September 16th, 2015
### New article form on 404 Not Found pages

This one has also been on the wishlist for a while. It's very common while building a Guide to 
create links to articles that don't exist yet. That was made much easier yesterday with relative 
Markdown links (`[[Title]]` expands to `[Title](/articles/title)`) and color-coded article existence 
checking (links to non-existent articles show up in red). 

Today this flow gets even better since you can now click those red links to non-existent articles 
and Orientation will present you with a new article form containing the URL slug converted in a title.

![example of the new 404 article handling](https://s3.amazonaws.com/f.cl.ly/items/0t1q1H0i2c1g2z3o3q1s/Screen%20Shot%202015-09-16%20at%203.27.40%20PM.png)

## September 15th, 2015
### Advanced Search vs. Fuzzy Search

After a few weeks trying to make fuzzy search (on title and content) work, it's now clear that this approach 
won't work, so we switched back to [advanced_search](https://github.com/textacular/textacular#usage) on the 
article title field only. This makes for a more intuitive search flow since it's far more common to search 
for something based on the article title (although tags should be added to that soon).

The sad part is that if the title doesn't contain the term you're looking for, now you're out of luck with 
search. I hope for now that the Guides feature makes up for that but I haven't given up hope on finding an 
even better way to make basic/advanced search cohabitate better with content-focused fuzzy search (full-text).

### Relative Markdown links

This is a feature I'm really happy to introduce because it really should have been
here since the beginning.

It's now possible to link to any article using either the article title or its URL
slug. Say you have an article titled "Onboarding", you can write the following
Markdown and the proper link will automatically be expanded once the article you're
editing is saved.

![Before Smart Links](https://s3.amazonaws.com/f.cl.ly/items/020Q0V1n1L3t2r3y1K2N/Screen%20Shot%202015-09-15%20at%206.07.41%20AM.png)

![After Smart Links](https://s3.amazonaws.com/f.cl.ly/items/1r3n2V2y231i0i1l3010/Screen%20Shot%202015-09-15%20at%206.07.21%20AM.png)

### Color-coded article existence check

Now when you link to an article title, slug or URL that doesn't exist on Orientation
you will see the color of the link change to red to indicate that an article is missing.

![Color for incorrect link](https://s3.amazonaws.com/f.cl.ly/items/0T1m433Z1l201C3r290O/Screen%20Shot%202015-09-15%20at%206.56.17%20AM.png)

## September 3rd, 2015
### Restrict Google Apps sign in to `ORIENTATION_EMAIL_WHITELIST` domain

Thanks to Bruno Miranda, it's now possible to display only the authorized Google Apps domain set in the `ORIENTATION_EMAIL_WHITELIST` environment variable in the Google sign in page.

This way instead of listing all the Google accounts a user has, only the one authorized to sign into Orientation will be displayed. This should reduce confusion among first-time users of Orientation and prevent failed sign in attempts.

## September 1st, 2015
### Emoji Support! :+1:

Thanks to Brandon Mathis it's now possible to use GitHub-style emojis in Orientation articles.

## August 29th, 2015
### Reduced queries on tags & article associations thanks to @fusion2004

This is a fix I should have worked on much earlier as tags and articles always generated a heap of N+1 queries for
no good reason when we fetched article or tag counts. I highly recommend merging in master into your forks at fe85cf0135c2ce02600034405de3ae167fc35373 or later to benefit from this significant reduction in queries on guide and article index pages.

### Uglifier security update
This is less exciting but worth mentioning, Mark Oleson also contributed a useful little PR to update the Uglifier version which had been vulnerable for a little while. Another great reason to merge master into your forks and deploy to production quickly.

### No more trouble when using the Heroku button

I took way to long to react on this but Michael Friis contributed [a nifty patch](https://github.com/orientation/orientation/pull/155) to fix recurring issues when the Heroku button because our app.json manifest was too tightly coupled to specific Heroku add-on plans.

## July 31st, 2015
### Search Finally Works!

![Pumpernickel Stew!](https://s3.amazonaws.com/f.cl.ly/items/0I0N34230b1T3A383h2L/Screen%20Shot%202015-07-31%20at%201.10.37%20AM.png)

After upgrading RSpec I finally decided to take a much needed second look in order to figure out why search was behaving so poorly (it basically did not work at all). I realized I was wholly misusing the wonderful textactular
gem that allows us to do full-text searching without anything fancy like Solr or Elastic Search.

And guess, what? It works. Search will now fuzzy (partial-match) search on article titles and their **entire content**. This is a very big deal because Orientation was predicated on the promise of instant search to reduce
the cognitive load of having to browse for something you don't understand.

Now're finally back in the land where if you have the word "Pumpernickel" anywhere within any article, a simple
search for `pumper` will bring up all the articles that contain any word which contains that — for example `pumpernickel`.

Additionally, I've fixed an issue where the articles listed on filtered articles pages (fresh, stale, popular)
did not reappear after the search form was re-submitted with no query or if the currently typed query
was removed. This makes the filtered article pages much more friendly they now behave once again like a
proper "filtered search" page.

I'm so very sorry to anyone who invested time in Orientation since it was open-sourced. This is a bug I had meant
to fix for literal years and for reasons I can't explain away, had never managed to.

## April 4th, 2015
### No more dependency on Amazon S3 and CarrierWave/Fog
Installing Orientation from scratch turned out to be a pain (even fore me) because S3's access policies are a huge pain and I couldn't even figure out how to make a properly segregated Orientation demo account on AWS without pulling hair.

Even without an avatar uploader, we still grab the avatar URL from Google OAuth if the person has one, so it seemed unjustifiable to depend on such a painful to setup service for a featuer that is trivial at best.

One thing that we'll have to address is default images for people who don't have one, but that shouldn't be too hard.

## March 29th, 2015
### Fuzzy search is back

![screenshot](https://s3.amazonaws.com/f.cl.ly/items/0Q2C021J1E3C1P3r2k2U/Screen%20Shot%202015-03-29%20at%202.40.59%20PM.png)

For now it's only on titles since there seems to be something wrong on the full-text indexing of the article content column, but it's better than what we used to have for sure.

If we ever enable full-text fuzzy search on article content again, we'll try to have search results return a preview of the line of content that matched the search keywords otherwise it's going to be very difficult for users to tell which search result is going to answer their question because they'll only see the title — which may not contain any of the search keywords they entered.

## March 28th, 2015
### Slack notifications

![screenshot](https://s3.amazonaws.com/f.cl.ly/items/0d100X1I310m1z1i0S0h/Screen%20Shot%202015-03-28%20at%202.46.08%20PM.png)

In a mad dash of excitement, I've added Slack notifications (via a webhook configurable using the `SLACK_WEBHOOK_URL` you can find in [`.env.example`](.env.example)). This is clearly an experimental and untested feature but I really wanted to play with it, so there you go.

### Article state pages
![screenshot](https://cloud.githubusercontent.com/assets/65950/6880178/c12d0ad6-d524-11e4-8c5b-91a2d1121e0f.png)

Each article state now has its own "state" page to easily find Fresh, Stale, or Rotten articles.

There's also two additional "states": Archived and Popular. Archived articles are excluded from search so it's good to be able to find them somewhere if they need to be referenced (or deleted). Popular articles are ordered by endorsements first, subscriptions, and a brand new visits counter third.

Hovering over each filter button displays a definition of each state, which should help with discoverability.

### Subscriptions page
![screenshot](https://s3.amazonaws.com/f.cl.ly/items/1M3I250g3m0N3U382G3D/Screen%20Shot%202015-03-28%20at%208.38.04%20AM.png)

There was no way to see who "cares" about what article (wants to be notified when the article is updated) so this Subscriptions page should do the trick. It also gives a good overview of how well-connected to the knowledge assembled inside Orientation your team is.

### Endorsements page
![screenshot](https://s3.amazonaws.com/f.cl.ly/items/1c0B0L2t110019110y1X/Screen%20Shot%202015-03-28%20at%208.39.34%20AM.png)

Speaking of caring, endorsements are a way for people to appreciate the documentation efforts of others and increase the authority of an article, so it's also interesting to have a page displaying recent endorsements.

I realize as I'm typing this that I may need to paginate this for active teams otherwise those two new pages are going to get slow fast. Oh well.

### Stale articles
Previously stale articles included rotten articles as well. I've decided to segregate these two scopes/states from now on because articles in these two categories require very different levels of attention from readers and editors.

### Article visits
This is an invisible feature for now (aside from the Popular Articles page which will be impacted by it) but I've just added a simple visits counter on articles. It's automatically incremented any time the show page for an article is loaded. I might consider making more user-specific stats in the future to help you find articles you've consulted a lot but this is a good first step.

### Article count in search field
![screenshot](https://s3.amazonaws.com/f.cl.ly/items/1V1R3b2z2A330f430k3c/Screen%20Shot%202015-03-28%20at%203.17.30%20PM.png)

On the article index page or even on article "state" pages (Fresh, Rotten, etc.) it was hard to know how many articles were being shown compared to each other "state". Now, the article count for the current scope is dynamically displayed in the search field.
