cask "tinycast@beta" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (beta channel). Run one beta Release to populate these.
  version "0.12.4-beta.128"
  sha256 "23a59cee2350491aca81f3281a4d48d452ce2a45f4d564dc7905b7390b1b6b1c"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg"
  name "Tinycast Beta"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history (beta channel)"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: :tahoe

  # Distinct bundle id (com.tinycast.app.beta) + app name, so beta installs
  # side-by-side with the stable cask.
  app "Tinycast Beta.app"

  # Self-signed (not notarized): strip the quarantine flag on every install and upgrade
  # so Gatekeeper won't block launch — no manual xattr needed.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Tinycast Beta.app"]
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
end
