cask "dracula-snippetslab" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "main"

  app_name = "SnippetsLab"
  mas_id = "1006087419"

  url "https://#{repo}/archive/#{branch}.zip", verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  source = staged_path/"#{tokens.last}-#{branch}"

  container = "#{Dir.home}/Library/Containers/com.renfei.#{app_name}"
  themes = Pathname "#{container}/Data/Library/Application Support/Themes"

  json = "Dracula.json"
  css = json.sub "json", "css"

  artifact source/json, target: themes/json
  artifact source/css,  target: themes.parent/"Markdown Themes/#{css}"

  preflight do
    error = "#{app_name} is not installed. Try: mas install #{mas_id}"
    raise error unless (appdir/"#{app_name}.app").directory?

    system "./generate.command", chdir: source
  end
end
