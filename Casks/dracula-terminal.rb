cask "dracula-terminal" do
  version "1.2.6"
  sha256 :no_check

  tokens = token.split "-"
  repo = "#{File.join "github.com", tokens}-app"
  branch = "main"
  app_name = tokens.last.capitalize
  theme = token.capitalize.tr "-", "."

  url "https://#{repo}/archive/#{branch}.zip",
      verified: repo
  name "Dracula for #{app_name}.app"
  desc "Dark theme for #{app_name}.app"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  livecheck do
    url "https://#{repo}/blob/#{branch}/#{theme}"
    regex(/Dracula Theme v?(\d+(?:\.\d+)+)/)
  end

  domain = "com.apple.#{app_name}"
  plist = "~/Library/Preferences/#{domain}.plist"
  keypath = "Window Settings.Dracula"

  postflight do
    xml = Plist.parse_xml staged_path/"#{tokens.last}-app-#{branch}/#{theme}"

    command = "defaults write -app #{app_name} '%s Window Settings' Dracula;"
    settings = %w[Default Startup].map { |setting| command % setting }
    system <<~EOS
      if pgrep -qax #{app_name}
      then open -a  #{app_name} #{theme}
      else plutil -insert '#{keypath}' -xml '#{xml.to_plist false}' #{plist}
      fi && #{settings.join}
    EOS
  end

  uninstall_postflight do
    system <<~EOS
      if pgrep -qax #{app_name}
      then exit 1
      else plutil -remove '#{keypath}' #{plist}
      fi
    EOS
    caveat = "You must manually delete the Dracula theme inside #{app_name}.app to uninstall #{token}."
    ohai "Caveats", caveat if $CHILD_STATUS.exitstatus.nonzero?
  end
end
