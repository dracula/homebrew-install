# [Homebrew](https://brew.sh) _[tap](https://docs.brew.sh/Taps)_ for Dracula

Homebrew _[formulae](https://docs.brew.sh/Cask-Cookbook)_ to easily install Dracula themes.

## Install

Easily install themes from [dracula/homebrew-install](./Casks):

``` sh
brew tap dracula/install
brew install --cask dracula-foo
```

Also, if you keep a [_Brewfile_](https://github.com/Homebrew/homebrew-bundle#usage), you can add something like this:

``` rb
# ~/.Brewfile
tap "dracula/install"
cask "dracula-foo"
```

## Contributing

`git config core.hooksPath .github/hooks` and follow the contribution [guide](https://docs.brew.sh/Adding-Software-to-Homebrew#writing-the-cask), or copy and adapt an [existing](./Casks) _[Cask](https://docs.brew.sh/Cask-Cookbook)_.

## `dracula-yaml-json` command

This tap comes with a simple [external command](https://docs.brew.sh/External-Commands) to convert source
[YAML](https://yaml.org) to [JSON](https://json.org), with Dracula `*COLOR` [aliases](https://educative.io/blog/advanced-yaml-syntax-cheatsheet#anchors) available from the
included [`Dracula.yml`](https://github.com/dracula/template/blob/6f20086e12c202435d68f73f81e1df8af58bab67/Dracula.yml) spec template.

See `brew dracula-yaml-json `[[`-`]`-h`[`elp`]](https://github.com/dracula/homebrew-install/blob/main/cmd/dracula-yaml-json.rb#L19-L32) for more.

## Team

These formulae are maintained by the following person(s) and a bunch of [awesome contributors](https://github.com/dracula/snippetslab/graphs/contributors).

| [![Daniel Bayley](https://github.com/danielbayley.png?size=100)](https://github.com/danielbayley) |
|:--------------------------------------------------------------------------------------------------|
| [Daniel Bayley](https://github.com/danielbayley)                                                  |

## Community

- [Twitter](https://twitter.com/draculatheme) - Best for getting updates about themes and new stuff.
- [GitHub](https://github.com/dracula/dracula-theme/discussions) - Best for asking questions and discussing issues.
- [Discord](https://draculatheme.com/discord-invite) - Best for hanging out with the community.

## License

[MIT License](./LICENSE)
