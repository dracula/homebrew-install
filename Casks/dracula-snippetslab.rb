cask "dracula-snippetslab" do
  version :latest
  sha256 :no_check

  name_first, = token.titlecase.split
  app_name = "SnippetsLab"
  mas_id = "1006087419"

  repo = Pathname "github.com/" + token.sub("-", "/")
  branch = "main"

  url "https://#{repo}/archive/#{branch}.zip", verified: repo.to_path
  name name_first
  desc "Dark theme for #{app_name}"
  homepage "https://#{name.first.downcase}theme.com/#{app_name.downcase}"

  container = "#{Dir.home}/Library/Containers/com.renfei.#{app_name}"
  app_support = "#{container}/Data/Library/Application Support"
  target = Pathname "#{app_support}/Themes/#{name.first}.json"

  staged_path = "#{cask.staged_path}/#{repo.basename}-#{branch}"

  artifact "#{staged_path}/#{target.basename}", target: target

  preflight do
    error = "#{app_name} is not installed. Try: mas install #{mas_id}"
    raise error unless Dir.exist? appdir/"#{app_name}.app"

    system "./generate.command", chdir: staged_path
  end
end
