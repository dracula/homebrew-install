cask "dracula-colorslurp" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens.first, token
  branch = "main"

  app_name = "ColorSlurp"
  mas_id = "1287239339"

  url "https://#{repo}/archive/refs/heads/#{branch}.zip", verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/"

  preflight do
    error = "#{app_name} is not installed. Try: mas install #{mas_id}"
    raise error unless (appdir/"#{app_name}.app").directory?

    command = <<~EOS
      PATH=$PATH:#{HOMEBREW_PREFIX}/bin
      ./generate.command
      open -a #{app_name} Dracula.cscollection
      sleep 0.2
      pkill #{app_name}
    EOS
    system command, chdir: staged_path/"#{token}-#{branch}"
  end

  caveats <<~EOS
    You must manually delete the #{tokens.first.capitalize} palette \
    inside #{app_name} to uninstall #{token}.
  EOS
end
