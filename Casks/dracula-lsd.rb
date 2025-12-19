cask "dracula-lsd" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  repo = File.join "github.com", tokens
  branch = "main"
  app_name = tokens.last.upcase

  url "https://#{repo}/archive/#{branch}.tar.gz",
      verified: repo
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  depends_on formula: tokens.last

  config = Pathname ENV.fetch "HOMEBREW_XDG_CONFIG_HOME", "#{Dir.home}/.config"
  config /= tokens.last

  default = config/"config.yaml"
  artifact "#{tokens.last}-#{branch}/#{default.basename}", target: default unless default.exist?

  theme = config/"colors.yaml"
  raise "Please remove existing theme before install." if caller[-2].end_with?("`install'") && theme.exist?

  artifact "#{tokens.last}-#{branch}/#{tokens.first}.yaml", target: theme

  caveats <<~EOS
    Cask requires a HOMEBREW_XDG_CONFIG_HOME environment variable to be set to match
    any existing XDG_CONFIG_HOME variable, to bypass the Homebrew environment filter.
  EOS
end
