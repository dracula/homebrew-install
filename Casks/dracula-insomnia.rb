cask "dracula-insomnia" do
  version "1.0.2"
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "master"
  app_name = tokens.last.capitalize

  url "https://#{repo}/archive/#{branch}.zip",
      verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  plugins = "#{Dir.home}/Library/Application Support/#{app_name}/plugins"
  plugin = "#{tokens.last}-plugin-theme-#{tokens.first}"

  livecheck do
    url "https://#{tokens.last}.rest/plugins/#{plugin}"
    regex(/Version\s.*?(\d+(?:\.\d+)+)/)
  end

  artifact "#{tokens.last}-#{branch}", target: "#{plugins}/#{plugin}"
end
