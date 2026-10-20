require "shellwords"

class Remopilot < Formula
  desc "Remote project gateway and paired machine agent"
  homepage "https://remopilot.com"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/remopilot/remopilot/releases/download/v1.0.24/remopilot-1.0.24-darwin-arm64.tar.gz"
      sha256 "cb7ec17a607a673a67168d1c53c1a0698d61b7949eda0928f4dda24e98a1a1fd"
    end
    on_intel do
      url "https://github.com/remopilot/remopilot/releases/download/v1.0.24/remopilot-1.0.24-darwin-x64.tar.gz"
      sha256 "919c736f4f0ce986b585fe98f96aa37d1c2c1b5384d2546c3d15e047efebac6c"
    end
  end

  skip_clean "libexec"

  def install
    # Preserve signed bytes, helper, Skills, receipts and relinking materials.
    # Package validation and activation happen outside Homebrew's install sandbox.
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
        echo "RemoPilot needs activation: remopilot homebrew --action install" >&2
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
      receipt for the reported count.
      brew cleanup/uninstall removes only the tap launcher and Cellar package.
      Managed programs, generations and machine data remain outside Cellar.
      Use RemoPilot service commands, not brew services, for this connection.
    EOS
  end

  test do
    # Version observation must not activate a service or modify user state.
    assert_match version.to_s, shell_output("#{(libexec/"remopilot").to_s.shellescape} version")
  end
end
