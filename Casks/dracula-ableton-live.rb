cask "dracula-ableton-live" do
  version :latest
  sha256 :no_check

  tokens = token.split "-", 2
  app_name = tokens.last.titlecase

  repo = File.join "github.com", tokens
  branch = "master"

  url "https://#{repo}/archive/#{branch}.zip", verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  ask = "#{name.first}.ask"
  source = "#{tokens.last}-#{branch}/#{ask}"

  edition = ENV["HOMEBREW_ABLETON_LIVE_EDITION"] || "lite"
  app, = Dir[appdir/"#{app_name} [0-9]* #{edition.capitalize}.app"].max
  target = "Contents/App-Resources/Themes/#{ask}"

  depends_on cask: "#{tokens.last}-#{edition.downcase}" unless app

  if app
    artifact source, target: "#{app}/#{target}"
  else
    installer manual: source
    uninstall delete: Dir["#{app}/#{target}"]
  end

  caveats <<~EOS
    Export a HOMEBREW_ABLETON_LIVE_EDITION environment variable to specify your
    edition of Live. This can be set in your shell startup file, for example:
      echo export HOMEBREW_ABLETON_LIVE_EDITION=suite >> ~/.zshrc

    Possible values are lite, intro, standard or suite. See the Ableton store
    for more details:
      https://ableton.com/shop/live
  EOS
end
