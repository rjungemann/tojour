# Tojour

Like AirDrop for the command line.

Make your computer available over Bonjour for someone to send you a file. Uses
SSL sockets.

## Installation

Install it yourself as:

    $ gem install tojour

## Usage

### Let Someone Send you a File

On your machine, run the following to wait for a file. Assuming your username is
`jbiebz`.

```bash
tojour -r jbiebz
```

Have your friend run the following to send you a file. Assuming the file you
want to send is located at `some_file.txt`.

```bash
tojour -s some_file.txt jbiebz
```

### Let Someone Pipe you a Log

Your friend wants to pipe you some data. On your machine, make your
machine available over Bonjour.

```bash
tojour -i jbiebz
```

On their machine, run a command, and pipe the output to `tojour`.

```bash
ruby -e 'loop { puts 'Wow!'; sleep 1 }' | tojour -o jbiebz
```

### Get Help

List arguments you can pass to `tojour`.

```bash
tojour
```

### List People Waiting for Files

List all the people on your network waiting for files or logs.

```bash
tojour -l
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run
`bin/tojour`.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tojour/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
