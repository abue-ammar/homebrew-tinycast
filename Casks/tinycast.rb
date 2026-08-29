cask "tinycast" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel). Placeholder until the first stable release is cut.
  version "0.10.5"
  sha256 "1bf26c2e432e89dc07a991998244d09de472ba703a05c61eefbb0b090c655c06"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as the Sequoia and universal casks, so no two can coexist.
  conflicts_with cask: [
    "abue-ammar/tinycast/tinycast-sequoia",
    "abue-ammar/tinycast/tinycast-universal",
  ]
  # `:tahoe` already means ">= macOS 26"; macOS 15 takes the `tinycast-sequoia` cask instead.
  depends_on macos: :tahoe
  # This DMG is arm64-only. Intel Macs run macOS 26 too, and take `tinycast-universal` instead.
  depends_on arch: :arm64

  app "Tinycast.app"

  # Detect whether this run is a fresh install or an upgrade. preflight runs before the
  # new bundle is staged into place, so if an app is already in appdir it's an upgrade.
  # We can't share state directly with postflight (different DSL objects), so drop a marker.
  preflight do
    if File.exist?("#{appdir}/Tinycast.app")
      FileUtils.touch("#{staged_path}/.upgrade")
    end
  end

  # Tinycast is signed with a stable self-signed identity (not an Apple Developer ID / not
  # notarized), so macOS quarantines it. Strip the flag on every install AND upgrade so
  # Gatekeeper won't block launch — the user never has to run xattr by hand. Only auto-launch
  # on a fresh install; upgrades stay silent so they don't steal focus. `uninstall quit:`
  # closed the old copy first.
  postflight do
    upgrade = File.exist?("#{staged_path}/.upgrade")
    FileUtils.rm_f("#{staged_path}/.upgrade")

    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Tinycast.app"]

    unless upgrade
      system_command "/usr/bin/open",
                     args: ["-g", "#{appdir}/Tinycast.app"]
    end
  end

  # Quit the running app before Homebrew replaces the bundle on upgrade/uninstall — otherwise
  # the update clobbers a live process. postflight relaunches it after an upgrade (not uninstall).
  uninstall quit: "com.tinycast.app"

  zap login_item: "Tinycast",
      trash:      [
        "~/Library/Application Support/com.tinycast.app",
        "~/Library/Caches/com.tinycast.app",
        "~/Library/Preferences/com.tinycast.app.plist",
        "~/Library/Saved Application State/com.tinycast.app.savedState",
      ]
end
