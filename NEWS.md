# News
Interesting new features added to this project will be documented here reverse chronologically.
This is [not a change log](CHANGELOG.md).

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
