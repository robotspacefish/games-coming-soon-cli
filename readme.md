# Games Coming Soon CLI Project

Retrieves information about games coming out within the next year from IGDB.com. It allows the user to choose from a list of platforms and the month they'd like to see game releases in.

## Prerequisites

* [Bundler](https://bundler.io/)

```
$ gem install bundler
```

## Installing

* Clone or download project
* Navigate into project root folder
* Bundle application

```
$ bundle install
```

## Deployment

Option 1:

```
$ ./bin/games_coming_soon
```

Option 2:

```
$ ruby/bin/games_coming_soon
```

## Built With

- [Ruby](https://www.ruby-lang.org/en/) - The language used
- [Nokogiri](https://rubygems.org/gems/nokogiri) - HTML,XML parser
- [Colorize](https://github.com/fazibear/colorize) - Ruby string class extension to set colors to text and backgrounds

## Author

- Jess Fischbach - [robotspacefish](https://github.com/robotspacefish)

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/robotspacefish/games-coming-soon-cli/blob/master/LICENSE) for details

## Acknowledgments

- [IGDB](https://www.igdb.com/) - For existing and providing a simple(ish) way to grab the info needed for this project
