cask "dracula-ableton-live" do
  version :latest
  sha256 :no_check

  tokens = token.split "-", 2
  name_first, app_name = tokens.map(&:titlecase)

  repo = File.join "github.com", tokens
  branch = "master"

  url "https://#{repo}/archive/#{branch}.zip", verified: repo
  name name_first
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  ask = "#{name.first}.ask"
  source = "#{tokens.last}-#{branch}/#{ask}"
  app, = Dir[appdir/"#{app_name} [0-9]*.app"].max

  depends_on cask: "#{tokens.last}-lite" unless app

  artifact source, target: "#{app}/Contents/App-Resources/Themes/#{ask}"
end
