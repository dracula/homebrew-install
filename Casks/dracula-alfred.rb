cask "dracula-alfred" do
  version "3"
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  app_name = tokens.last.capitalize

  url "https://#{repo}", verified: repo, using: :git
  name "Dracula for #{app_name} #{version.major}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  livecheck do
    url "https://#{repo}#readme"
    strategy :page_match
    name = @package_or_resource.name.first.downcase.split.join "-"
    regex Regexp.new name.sub version, "([0-9])"
  end

  bundle_id = "com.runningwithcrayons.Alfred-Preferences"
  syncfolder = File.expand_path `defaults read #{bundle_id} syncfolder`.chomp
  syncfolder = "#{Dir.home}/Library/Application Support/Alfred" unless $CHILD_STATUS.success?
  themes = "#{syncfolder}/Alfred.alfredpreferences/themes"

  artifact "Dracula.alfredappearance",
           target: "#{themes}/theme.homebrew.#{tokens.first}/theme.json"

  preflight { system "git pull origin refs/pull/10/head --quiet", chdir: staged_path }

  uninstall_postflight { @cask.artifacts.to_a[1].target.parent.delete }
end
