### Contribution Guidelines

1. Create a local branch, make your changes and get them tested and code-reviewed.
2. Checkout the `pseudo-master` and make sure you have pulled the latest
3. Merge your local branch in pseudo-master.
4. Push your changes to pseudo-master
5. Deploy pseudo-master to QA `git push heroku-qa pseudo-master:master`
6. To deploy to production replace `heroku-qa` with `heroku`

------------------

Ensure your local .git/config contains the following

```
[remote "heroku-qa"]
  url = https://git.heroku.com/dox-orientation-qa.git
  fetch = +refs/heads/*:refs/remotes/heroku/*
[remote "heroku"]
  url = https://git.heroku.com/dox-orientation.git
  fetch = +refs/heads/*:refs/remotes/heroku/*
```
