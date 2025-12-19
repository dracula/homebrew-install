require_relative "../lib/utils"

cask "dracula-wallpaper" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "master"

  url "https://#{repo}/archive/#{branch}.zip",
      verified: repo
  name token.titlecase
  desc "Wallpapers with the theme and colors of Dracula"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  wallpapers = "#{Dir.home}/Library/Desktop Pictures"

  %w[base macos].each do |wallpaper|
    artifact "#{tokens.last}-#{branch}/first-collection/#{wallpaper}.png",
             target: "#{wallpapers}/Dracula-#{wallpaper}.png"
  end

  caveats <<~EOS
    Be sure to add the #{wallpapers} folder:
      System Settings > Wallpaper > Add Folder…
      open x-apple.systempreferences:com.apple.Wallpaper-Settings.extension
  EOS
end
