cask "tinycast-sequoia" do
  # `version` and `sha256` are bumped automatically by the tinycast release-sequoia workflow.
  # Placeholder until the first Sequoia release is cut.
  version "0.9.4-sequoia"
  sha256 "30aadec805ef5e160608aa0a72a186243dd10d202d7e8d35e94253647e3f96b8"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as the mainline cask on purpose — that's what preserves prefs and
  # the Accessibility grant across a later upgrade to macOS 26 — so the two can never coexist.
  conflicts_with cask: "abue-ammar/tinycast/tinycast"
  # `:sequoia` means ">= macOS 15", matching this binary's actual floor. Homebrew has no
  # non-deprecated way to express a maximum, so an upper bound is enforced from the other side:
  # `tinycast` requires >= :tahoe, so a Sequoia machine can never be handed the macOS 26 build.
  depends_on macos: :sequoia

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
