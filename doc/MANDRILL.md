# Mandril Templates

By default Orientation uses Mandrill to send transactional emails so here are the basic templates you can use. 

The names of the templates have to match otherwise an exception will be raised:

## Article Endorsement Notification

slug: `article-endorsement-notification`

```html
<p>Hey!</p>

<p><a href="*|ENDORSER_URL|*" target="_blank">*|ENDORSER_NAME|*</a> found <a href="*|URL|*" target="_blank">*|ARTICLE_TITLE|*</a> so useful they endorsed it.</p>

<p>That must feel nice.</p>

<p>Oh, and your hair looks amazing today,<br/>
<strong>HAL.</strong></p>
```

## Article Rotten Update

slug: `article-rotten-update`

```html
<p>Howdy,</p>

<p><a href="*|REPORTER_URL|*" target="_blank">*|REPORTER_NAME|*</a> has marked <a href="*|URL|*" target="_blank">*|ARTICLE_TITLE|*</a> as rotten.</p>

<p>This kind of a mean way for them to say they noticed it was out of date and would really appreciate it if you could <a href="*|URL|*" target="_blank">take a moment to update it</a>.</p>

<p>Just so you know, anyone who subscribes to your article will be emailed once you update it, so I bet you'll get major brownie points for that.</p>

<p>Thanks for fighting internal knowledge rot,<br/>
<strong>HAL.</strong></p>
```

## Article Subscription Update

slug: `article-subscription-update`

```html
<p>Howdy,</p>

<p>You have subscribed to updates from <a href="*|URL|*" target="_blank">*|ARTICLE_TITLE|*</a>.</p>

<p>This article was just updated, so you probably want to <a href="*|URL|*" target="_blank">check it out</a>.</p>

<p>Thanks for fighting internal knowledge rot,<br/>
<strong>HAL.</strong></p>
```

## Stale Article Alert

slug: `stale-article-alert`

```html
<p>Howdy,</p>

<p>It's been at least 6 months since you wrote these Orientation articles:</p>

<ul>
  *|CONTENT|*
</ul>

<p>Do you mind taking a look to see if they're still up-to-date? If everything looks good, you can hit the "Mark Fresh" link.</p>

<p>Thanks for fighting internal knowledge rot,<br/>
<strong>HAL.</strong></p>
```
