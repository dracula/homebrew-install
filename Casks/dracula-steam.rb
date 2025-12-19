cask "dracula-steam" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "master"
  app_name = tokens.last.capitalize

  url "https://#{repo}/archive/#{branch}.zip",
      verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  depends_on cask: tokens.last unless (appdir/"#{app_name}.app").directory?

  app_support = Pathname "#{Dir.home}/Library/Application Support/#{app_name}"
  skins = app_support/"#{app_name}.AppBundle/#{app_name}/Contents/MacOS/skins"
  target = skins/"Dracula"

  artifact staged_path/"#{tokens.last}-#{branch}", target: target

  postflight { system "./install.sh", chdir: target }

  uninstall_postflight do
    script = <<~EOS
      /bin/rm custom*.css
      /bin/mv {steam,}library.css
      /bin/mv {steam,}1010.css
    EOS
    system script, chdir: skins.parent/"steamui/css"
    skins.delete if skins.empty?
  end
end
