cask "dracula-xcode" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "githubusercontent.com", tokens
  branch = "master"
  theme = "Dracula.xccolortheme"

  app_name = tokens.last.capitalize
  mas_id = "497799835"

  url "https://raw.#{repo}/#{branch}/#{theme}",
      verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  artifact theme, target: "#{Dir.home}/Library/Developer/Xcode/UserData/FontAndColorThemes/#{theme}"

  preflight do
    error = "#{app_name} is not installed. Try: mas install #{mas_id}"
    raise error unless (appdir/"#{app_name}.app").directory?
  end
end
