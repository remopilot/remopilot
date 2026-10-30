require "shellwords"

class Remopilot < Formula
  desc "Remote project gateway and paired machine agent"
  homepage "https://remopilot.com"
  version '1.0.26'
  license :cannot_represent
  skip_clean "libexec"

  on_macos do
    on_arm do
      url 'https://github.com/remopilot/remopilot/releases/download/v1.0.26/remopilot-1.0.26-darwin-arm64.tar.gz'
      sha256 '5d792c78018858f3f96871d7066155c8da45338084c623ea8ff4e9d0ad46e678'
    end
    on_intel do
      url 'https://github.com/remopilot/remopilot/releases/download/v1.0.26/remopilot-1.0.26-darwin-x64.tar.gz'
      sha256 '808138df3669d15f424bd7bc9bf36d18cb5f66be8c7c293a3edab9a178298b76'
    end
  end

  def install
    # Preserve signed bytes, helper, Skills, receipts and relinking materials.
    # Package validation/activation happens outside Homebrew's install sandbox.
    libexec.install Dir["*", ".??*"].reject { |path| [".", ".."].include?(path) }
    (bin/"remopilot").write <<~SH
      #!/bin/sh
      set -eu
      package=#{libexec.to_s.shellescape}
      work_directory="${REMOPILOT_WORK_DIRECTORY-$HOME}"
      prefix="${REMOPILOT_HOMEBREW_PREFIX:-$work_directory/.remopilot}"
      if [ "${1:-}" = homebrew ]; then
        shift
        if [ -n "${REMOPILOT_HOMEBREW_PREFIX:-}" ]; then
          exec "$package/remopilot" homebrew --package "$package" --prefix "$prefix" "$@"
        fi
        exec "$package/remopilot" homebrew --package "$package" "$@"
      fi
      if [ ! -x "$prefix/bin/remopilot" ]; then
        echo 'RemoPilot needs activation: remopilot homebrew --action install' >&2
        exit 1
      fi
      exec "$prefix/bin/remopilot" "$@"
    SH
    (bin/"remopilot").chmod 0755
  end

  def caveats
    <<~EOS
      Activate this package after install or upgrade:
        remopilot homebrew --action install
      For a new machine, then run:
        remopilot setup
      Existing configuration, pairing and permissions are retained.
      macOS managed services use a direct update. Tasks and gateway sessions
      that are running during the switch are interrupted; read the update
      receipt for the reported count. No rainbow generation is used.
      brew cleanup/uninstall removes only the tap launcher and Cellar package.
      Managed programs, generations and machine data remain outside Cellar.
      Use RemoPilot service commands, not brew services, for this connection.
    EOS
  end

  test do
    # Version observation must not activate a service or modify a user's state.
    assert_match version.to_s, shell_output("#{(libexec/"remopilot").to_s.shellescape} version")
  end
end
