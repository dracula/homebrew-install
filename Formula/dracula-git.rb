class DraculaGit < Formula
  desc "Dark theme for Git"
  homepage "https://draculatheme.com/git#readme"
  ORG = "https://github.com/dracula".freeze
  url "#{ORG}/git/trunk", using: :svn
  version "1.0.0"
  license "MIT"

  def install
    doc.install_metafiles
    prefix.install "config/gitconfig"
  end

  def caveats
    <<~EOS
      To activate Dracula, run:
        git config --global include.path #{opt_prefix}/gitconfig
    EOS
  end

  test do
    system "git init && git config include.path #{opt_prefix}/gitconfig"
    scheme = shell_output "git config url.#{ORG}/.insteadOf"
    assert_match "dracula://", scheme

    color = shell_output "git config color.branch.current"
    assert_match "cyan bold reverse", color
  end
end
