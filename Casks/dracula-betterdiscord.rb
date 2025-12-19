cask "dracula-betterdiscord" do
  version :latest
  sha256 :no_check

  app_name = "BetterDiscord"
  tokens = token.split "-"
  repo = "githubusercontent.com/#{tokens.first}/#{app_name}"
  branch = "master"
  css = "Dracula_Official.theme.css"

  url "https://raw.#{repo}/#{branch}/#{css}",
      verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  depends_on cask: "#{tokens.last}-installer"

  themes = Pathname "#{Dir.home}/Library/Application Support/#{app_name}/themes"

  artifact css, target: themes/css
end
