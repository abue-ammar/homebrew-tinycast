cask "tinycast-sequoia" do
  # `version` and `sha256` are bumped automatically by the tinycast release-sequoia workflow.
  # Placeholder until the first Sequoia release is cut.
  version "0.9.7-sequoia"
  sha256 "8953ef2d8ed98c281931122253547d249c05dfa0863b443852025454356e861e"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/abue-ammar/tinycast"

  # Same app name and bundle id as the macOS 26 casks on purpose — that's what preserves prefs and
  # the Accessibility grant across a later upgrade to macOS 26 — so no two can ever coexist.
  conflicts_with cask: [
    "abue-ammar/tinycast/tinycast",
    "abue-ammar/tinycast/tinycast-universal",
  ]
  # `:sequoia` means ">= macOS 15", matching this binary's actual floor. Homebrew has no
  # non-deprecated way to express a maximum, so an upper bound is enforced from the other side:
  # the macOS 26 casks require >= :tahoe, so a Sequoia machine can never be handed one.
  depends_on macos: :sequoia

  app "Tinycast.app"

  # Detect whether this run is a fresh install or an upgrade. preflight runs before the
  # new bundle is staged into place, so if an app is already in appdir it's an upgrade.
  # Steps can't hand state to the postflight plan directly, so drop a marker in staged_path.
  preflight_steps do
    if_path_exists "Tinycast.app", base: :appdir do
      touch ".upgrade"
    end
  end

  # Tinycast is signed with a stable self-signed identity (not an Apple Developer ID / not
  # notarized), so macOS quarantines it. Strip the flag on every install AND upgrade so
  # Gatekeeper won't block launch — the user never has to run xattr by hand. Only auto-launch
  # on a fresh install; upgrades stay silent so they don't steal focus. `uninstall quit:`
  # closed the old copy first.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Tinycast.app"]

    # The marker outlives this guard: `unless_path_exists` is evaluated when it is reached,
    # so the removal below must stay last.
    unless_path_exists ".upgrade" do
      run "/usr/bin/open", args: ["-g", "{{appdir}}/Tinycast.app"]
    end

    remove ".upgrade"
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
