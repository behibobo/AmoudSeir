# Byebug

[![Version][gem]][gem_url]
[![Tidelift][tid]][tid_url]
[![Coverage][cov]][cov_url]
[![Gitter][irc]][irc_url]

[gem]: https://img.shields.io/gem/v/byebug.svg
[tid]: https://tidelift.com/badges/github/deivid-rodriguez/byebug
[cov]: https://api.codeclimate.com/v1/badges/f1a1bec582752c22da80/test_coverage
[irc]: https://img.shields.io/badge/IRC%20(gitter)-devs%20%26%20users-brightgreen.svg

[gem_url]: https://rubygems.org/gems/byebug
[tid_url]: https://tidelift.com/subscription/pkg/rubygems-byebug?utm_source=rubygems-byebug&utm_medium=readme_badge
[cov_url]: https://codeclimate.com/github/deivid-rodriguez/byebug/test_coverage
[irc_url]: https://gitter.im/deivid-rodriguez/byebug

Byebug is a simple to use and feature rich debugger for Ruby. It uses the
TracePoint API for execution control and the Debug Inspector API for call stack
navigation. Therefore, Byebug doesn't depend on internal core sources. Byebug is also
fast because it is developed as a C extension and reliable because it is supported
by a full test suite.

The debugger permits the ability to understand what is going on _inside_ a Ruby program
while it executes and offers many of the traditional debugging features such as:

* Stepping: Running your program one line at a time.
* Breaking: Pausing the program at some event or specified instruction, to
  examine the current state.
* Evaluating: Basic REPL functionality, although [pry] does a better job at
  that.
* Tracking: Keeping track of the different values of your variables or the
  different lines executed by your program.

## Build Status

Linux [![Cir][cir]][cir_url]
Windows [![Vey][vey]][vey_url]

[cir]: https://circleci.com/gh/deivid-rodriguez/byebug/tree/master.svg?style=svg
[tra]: https://api.travis-ci.org/deivid-rodriguez/byebug.svg?branch=master
[vey]: https://ci.appveyor.com/api/projects/status/github/deivid-rodriguez/byebug?svg=true

[cir_url]: https://circleci.com/gh/deivid-rodriguez/byebug/tree/master
[tra_url]: https://travis-ci.org/deivid-rodriguez/byebug
[vey_url]: https://ci.appveyor.com/project/deivid-rodriguez/byebug

## Requirements

MRI 2.3.0 or higher.

## Install

```shell
gem install byebug
```

Alternatively, if you use `bundler`:

```shell
bundle add byebug --group "development, test"
```

## Usage

### From within the Ruby code

Simply include `byebug` wherever you want to start debugging and the execution will
stop there. For example, if you were debugging Rails, you would add `byebug` to
your code:

```ruby
def index
  byebug
  @articles = Article.find_recent
end
```

And then start a Rails server:

```shell
bin/rails s
```

Once the execution gets to your `byebug` command, you will receive a debugging prompt.

### From the command line

If you want to debug a Ruby script without editing it, you can invoke byebug from the command line.

```shell
byebug myscript.rb
```

## Byebug's commands

Command     | Aliases         | Subcommands
-------     | -------         | -----------
`backtrace` | `bt` `w` `where`|
`break`     | `b`             |
`catch`     | `cat`           |
`condition` | `cond`          |
`continue`  | `c` `cont`      |
`debug`     |                 |
`delete`    | `del`           |
`disable`   | `dis`           | `breakpoints` `display`
`display`   | `disp`          |
`down`      |                 |
`edit`      | `ed`            |
`enable`    | `en`            | `breakpoints` `display`
`finish`    | `fin`           |
`frame`     | `f`             |
`help`      | `h`             |
`history`   | `hist`          |
`info`      | `i`             | `args` `breakpoints` `catch` `display` `file` `line` `program`
`interrupt` | `int`           |
`irb`       |                 |
`kill`      |                 |
`list`      | `l`             |
`method`    | `m`             | `instance`
`next`      | `n`             |
`pry`       |                 |
`quit`      | `q`             |
`restart`   |                 |
`save`      | `sa`            |
`set`       |                 | `autoirb` `autolist` `autopry` `autosave` `basename` `callstyle` `fullpath` `histfile` `histsize` `linetrace` `listsize` `post_mortem` `savefile` `stack_on_error` `width`
`show`      |                 | `autoirb` `autolist` `autopry` `autosave` `basename` `callstyle` `fullpath` `histfile` `histsize` `linetrace` `listsize` `post_mortem` `savefile` `stack_on_error` `width`
`skip`      | `sk`            |
`source`    | `so`            |
`step`      | `s`             |
`thread`    | `th`            | `current` `list` `resume` `stop` `switch`
`tracevar`  | `tr`            |
`undisplay` | `undisp`        |
`untracevar`| `untr`          |
`up`        |                 |
`var`       | `v`             | `all` `constant` `global` `instance` `local`

## Semantic Versioning

Byebug attempts to follow [semantic versioning](https://semver.org) and
bump major version only when backwards incompatible changes are released.
Backwards compatibility is targeted to [pry-byebug] and any other plugins
relying on `byebug`.

## Getting Started

Read [byebug's markdown
guide](https://github.com/deivid-rodriguez/byebug/blob/master/GUIDE.md) to get
started. Proper documentation will be eventually written.

## Related projects

* [pry-byebug] adds `next`, `step`, `finish`, `continue` and `break` commands
  to `pry` using `byebug`.
* [ruby-debug-passenger] adds a rake task that restarts Passenger with Byebug
  connected.
* [minitest-byebug] starts a byebug session on minitest failures.
* [sublime_debugger] provides a plugin for ruby debugging on Sublime Text.
* [atom-byebug] provides integration with the Atom editor [EXPERIMENTAL].

## Contribute

See [Getting Started with Development](CONTRIBUTING.md).

## Funding

Subscribe to [Tidelift] to ensure byebug stays actively maintained, and at the
same time get licensing assurances and timely security notifications for your
open source dependencies.

You can also help `byebug` by leaving a small (or big) tip through [Liberapay].

## Security contact information

Please use the Tidelift security contact to [report a security vulnerability].
Tidelift will coordinate the fix and disclosure.

## Credits

Everybody who has ever contributed to this forked and reforked piece of
software, especially:

* @ko1, author of the awesome TracePoint API for Ruby.
* @cldwalker, [debugger]'s maintainer.
* @denofevil, author of [debase], the starting point of this.
* @kevjames3 for testing, bug reports and the interest in the project.
* @FooBarWidget for working and helping with remote debugging.

[debugger]: https://github.com/cldwalker/debugger
[pry]: https://github.com/pry/pry
[debase]: https://github.com/denofevil/debase
[pry-byebug]: https://github.com/deivid-rodriguez/pry-byebug
[ruby-debug-passenger]: https://github.com/davejamesmiller/ruby-debug-passenger
[minitest-byebug]: https://github.com/kaspth/minitest-byebug
[sublime_debugger]: https://github.com/shuky19/sublime_debugger
[atom-byebug]: https://github.com/izaera/atom-byebug
[Liberapay]: https://liberapay.com/byebug/donate
[Tidelift]: https://tidelift.com/subscription/pkg/rubygems-byebug?utm_source=rubygems-byebug&utm_medium=readme_text
[report a security vulnerability]: https://tidelift.com/security
