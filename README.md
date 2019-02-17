# Dougal

Do you even Agile? Because Dougal here is an opinionated project management helper for people using Trello and (optionally) Slack. Superb!

Dougal helps you by generating Trello TODO/DOING/DONE/ABANDONED lists as a convenient text summary. It can post them to Slack too. You could set up a cron job to post a fresh project status each day during your standup call. Champion!

# Installation using Ruby+Gems

1. Ensure Ruby is on your system (verify by running `ruby -v`)
2. `gem install dougal` # once it's on rubygems.
3. Run `dougal`. It will generate a config file if not already present.
4. Open the config file and run `dougal report` again to generate the report.

# Installation using Docker

Installing via Docker can be simpler and less headaches with conflicts and compilation.

1. Ensure Docker is on your system.
2. docker build -t dougal https://github.com/playerfm/dougal
3. Run `docker run --mount=target=/root/.config,type=bind,source=$HOME/.config -it dougal`. It will generate a config file (on your host system) if not already present.
4. Open the config file and run the above command ending with `dougal report` to generate the report.

# Configuring your projects

For each project, you'll specify:

* `trello_board`: The Trello board URL.
* `slack_channel`: The Slack channel, if you want to post the message to Slack. Otherwise, it will be output on stdout.
* `members`: A `true` or `false` preference indicating if the report is to be split into a separate list per member.

# Configuring Trello

1. Ensuring you're logged into Trello, get your [Trello API key here](https://trello.com/app-key) and add it to the Dougal config file.
2. Visit the "Token" link shown just below the key. Approve the request on the following page and your token will be shown. Put the token in the Dougal config file as trello_oauth_token.

Dougal will scan all cards in lists titled as `TODO` `DOING`, `DONE`, and `ABANDONED`. These names can appear anywhere in the title and any uppercase/lowercase combination (e.g. "TODO (Jane)", "Abandoned (not needed)") You don't need to have all these lists if you don't want to. You can also have more than one list, e.g. "TODO (Urgent)", "TODO (Soon)". Marvellous!

# Configuring Slack (optional)

1. [Create a new Slack project here](https://api.slack.com/apps?new_app=1)
2. From the side menu, visit "Oauth & Permissions"
3. In "Select Permission Scopes", add "chat:write:bot" and save changes
4. From top of the page, click "Install App to Workspace"
5. Approve the request on the following page your token will be shown. Put the token in the Dougal config file as slack_oauth_token.

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests (no custom tests yet!). You can also run `bin/console` for an interactive prompt that will allow you to experiment. Stellar!

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org). Awesome!

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/playerfm/dougal. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Rad!

# Wishlist

* Testing (based on public Trello and Slack instances)
* Durations per status (based on estimates in Trello card)
* Changes (indicate new and moved tasks in past day, new tasks since after sprint began)

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). Deluxe!

# Code of Conduct

Everyone interacting in the Dougal project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/playerfm/dougal/blob/master/CODE_OF_CONDUCT.md).  Solid!
