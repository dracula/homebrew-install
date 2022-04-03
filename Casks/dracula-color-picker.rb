cask "dracula-color-picker" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "main"

  url "https://#{repo}/archive/refs/heads/#{branch}.zip", verified: repo
  name tokens.first.capitalize
  desc "Dark theme for the native Color Picker"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  staged = staged_path/"#{token}-#{branch}"
  clr = "#{name.first}.clr"

  artifact staged/clr, target: "#{Dir.home}/Library/Colors/#{clr}"

  preflight { system "./generate.command", chdir: staged }
end
