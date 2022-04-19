cask "dracula-gitkraken" do
  version "0.3.0"
  sha256 "f73bfdae18f619776931c5fa5f9937ed67bb4f726be70dea8b6a117282254baa"

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  app_name = "GitKraken"

  url "https://#{repo}/archive/refs/tags/v#{version}.zip", verified: repo
  name tokens.first.capitalize
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  depends_on cask: tokens.last unless Dir[appdir/"#{app_name}.app"].any?

  themes = "#{Dir.home}/.gitkraken/themes"
  target = "#{tokens.first}-theme.jsonc"
  artifact "#{tokens.last}-#{version}/#{target}", target: "#{themes}/#{target}"
end
