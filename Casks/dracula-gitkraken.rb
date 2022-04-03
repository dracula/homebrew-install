cask "dracula-gitkraken" do
  version "0.2.0"
  sha256 "fdc3a3dce961924eab14250e8d5ce9255a3d0064c846ee0dd92ccb5ff01690f0"

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
