cask "tinycast" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel). Placeholder until the first stable release is cut.
  version "0.7.4"
  sha256 "8ac874369502327a6962f1d7c052b29801b42f8c2fd14372804ec3ac28ee9d1f"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: :tahoe

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
