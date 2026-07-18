cask "tinycast@beta" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (beta channel). Run one beta Release to populate these.
  version "0.6.1-beta.24"
  sha256 "d010557fa1e3988f0329e8a313d019fa63f74a5a8ddb101a0bfd40c26a1dd5af"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast Beta"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history (beta channel)"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: :tahoe

  # Distinct bundle id (com.tinycast.app.beta) + app name, so beta installs
  # side-by-side with the stable cask.
  app "Tinycast Beta.app"

  # Self-signed (not notarized): strip the quarantine flag on every install and upgrade
  # so Gatekeeper won't block launch — no manual xattr needed. Then relaunch in the
  # background so an upgrade lands the user back in a running app.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Tinycast Beta.app"]
    system_command "/usr/bin/open",
                   args: ["-g", "#{appdir}/Tinycast Beta.app"]
  end

  # Quit the running app before Homebrew replaces the bundle on upgrade/uninstall.
  uninstall quit: "com.tinycast.app.beta"

  zap login_item: "Tinycast Beta",
      trash:      [
        "~/Library/Application Support/com.tinycast.app.beta",
        "~/Library/Caches/com.tinycast.app.beta",
        "~/Library/Preferences/com.tinycast.app.beta.plist",
        "~/Library/Saved Application State/com.tinycast.app.beta.savedState",
      ]

  caveats <<~EOS
    Tinycast Beta is not signed or notarized. Homebrew clears the macOS quarantine
    flag for you automatically on install and every update, so there's nothing to run.
    Upgrading via `brew` quits and relaunches Tinycast Beta for you.
  EOS
end
