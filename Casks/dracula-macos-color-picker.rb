cask "dracula-macos-color-picker" do
  version :latest
  sha256 :no_check

  tokens = token.split "-", 2
  repo = File.join "github.com", tokens
  branch = "main"
  app_name = "Color Picker"

  url "https://#{repo}/archive/refs/heads/#{branch}.zip", verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for the native #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  source = staged_path/"#{tokens.last}-#{branch}/Dracula.clr"
  artifact source, target: "#{Dir.home}/Library/Colors/#{source.basename}"

  preflight do
    ENV["PATH"] += ":#{HOMEBREW_PREFIX}/bin"
    system "./generate.command", chdir: source.parent
  end
end
