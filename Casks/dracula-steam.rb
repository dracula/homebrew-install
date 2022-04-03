cask "dracula-steam" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  app_name = tokens.last.capitalize

  url "https://#{repo}", verified: repo, using: :git
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  depends_on cask: tokens.last unless (appdir/"#{app_name}.app").directory?

  app_support = Pathname "#{Dir.home}/Library/Application Support/#{app_name}"
  skins = app_support/"#{app_name}.AppBundle/#{app_name}/Contents/MacOS/skins"
  target = skins/"Dracula"

  artifact staged_path, target: target

  postflight do
    script = <<~EOS
      git pull origin refs/pull/35/head --quiet
      ./install.sh
    EOS
    system script, chdir: target

    success = "#{@cask.token} was successfully installed!"
    success.prepend "#{Homebrew::EnvConfig.install_badge}  " unless Homebrew::EnvConfig.no_emoji?
    puts success
    exit 0
  end

  uninstall_postflight do
    script = <<~EOS
      /bin/rm custom*.css
      /bin/mv {steam,}library.css
      /bin/mv {steam,}7.css
    EOS
    system script, chdir: skins.parent/"steamui/css"
    skins.delete if skins.empty?
  end
end
