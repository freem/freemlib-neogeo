# How to contribute

Ideally, this wouldn't be a one-person project, as it would take forever.
Therefore, I'm absolutely open to pull requests, as long as you realize what
contributing to the project entails.

## Prerequisites

* Create a [GitHub account](https://github.com/signup/free) if you haven't already.
* Check the [issue list](https://github.com/freem/freemlib-neogeo/issues) for your
issue/idea, and if it doesn't exist already, create a new one.
	* For bugs, describe the issue in as much detail as you can, including steps to
	reproduce, if possible. Please mention the earliest version you know is affected.
	Failing that, just mention what version or checkout date/hash you experienced
	the bug on.
	* For new ideas/code, it is recommended to submit an issue as a feature request
	before immediately issuing a pull request, as discussion can be had. Of course,
	if your code is finished and tested, there is nothing wrong with having this
	discussion on a pull request. ;)
* If you are able to fix a bug and feel like doing so, fork the repository on GitHub.

## Make Changes

* In your forked repository, create a topic branch for your upcoming patch. (e.g. `trackball-support` or `fix-banking`)
	* Usually this is based on the master branch. Only target release branches if
	you are certain your fix needs to be on that branch.
	* To quickly create a topic branch based on master:
	`git branch fix/master/my_contribution master`

	Then checkout the new branch with `git checkout fix/master/my_contribution`.

	For the time being, please avoid working directly on the `master` branch.
	This may change in the future, especially if ownership of the repo is
	transferred to a group, or if other people are added as committers.
* Make sure you stick to the coding style that is used already.
* Use the `.editorconfig` file if you want. It doesn't matter too much.
* Make commits of logical units and describe them properly.
* Ideally, check for unnecessary whitespace with `git diff --check` before committing.
However, I don't even do this most days, so don't stress about it.
* If possible, submit examples for your patch/new feature so it can be tested easily.
* Assure nothing is broken by running all the examples.

## Submit Changes

* Push your changes to a topic branch in your fork of the repository.
* Open a pull request on the branch you want to patch.
* If not done in commit messages (which you really should do) please reference and
update your issue with the code changes. But _please do not close the issue yourself_.
* At this time, @freem is the arbiter of all changes. As long as your stuff works
in MAME/MESS, it'll probably be accepted. If it's known to work on real hardware,
then there's a very large chance it will be accepted.

## Alternate Methods

For those who may not want to deal with the pull request system, please visit #neogeodev
IRC on chat.freenode.net and ask for freem_inc.

# Additional Resources

* [General GitHub documentation](http://help.github.com/)
* [GitHub pull request documentation](http://help.github.com/send-pull-requests/)
* [Read the Issue Guidelines by @necolas](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md) for more details
* [A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
