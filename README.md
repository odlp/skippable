# Skippable

Skippable helps you skip slow commands unless certain files changed. This can be
handy on CI, where valuable time, money, and CO₂ are often wasted by repeatedly
running the same command when nothing changed.

For example [License Finder](https://github.com/pivotal/LicenseFinder) takes ~45
seconds to run on a project with Ruby gems and NPM dependencies. In this example
there's no need to check the licenses if the dependency lockfiles didn't change.

## Usage

Add Skippable to your Gemfile:

```ruby
group :development do
  gem "skippable", require: false
end
```

Setup a `.skippable.yml` config file with one or more tasks:

```yaml
tasks:
  expensive_op:
    command: bundle exec my_slow_command
    paths:
      - lockfile_a
      - lockfile_b
```

Run the task using `skippable`:

```
bundle exec skippable expensive_op
```

- If the cache was cold OR the lockfiles changed, the specified command will
be run
- If the cache is warm, and the lockfiles haven't changed, the command
will be skipped

Finally, cache the following directory to persist state across builds:

```
tmp/skippable
```

## Example

```yaml
# .skippable.yml
tasks:
  license_finder:
    command: bundle exec license_finder
    paths:
      - Gemfile.lock
      - yarn.lock
```

Invocation:

```
bundle exec skippable license_finder
```
