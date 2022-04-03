cask "dracula-mailspring" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "master"
  app_name = tokens.last.capitalize

  url "https://#{repo}/archive/#{branch}.zip", verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  depends_on cask: tokens.last unless (appdir/"#{app_name}.app").directory?

  target = "#{Dir.home}/Library/Application Support/#{app_name}/packages/Dracula"

  artifact staged_path/"#{app_name}-#{branch}", target: target
end
