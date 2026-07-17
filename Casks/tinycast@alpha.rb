cask "tinycast@alpha" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (alpha channel). Run one alpha Release to populate these.
  version "0.5.3-alpha.18"
  sha256 "95dc45270a3f2999568607c87d0b3f1c76f1116a9b2c4507ab37ebe0e23b9cc8"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast Alpha"
  desc "Tinycast — A tiny, fully native macOS launcher, hotkeys, and clipboard history (alpha channel)"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: ">= :tahoe"

  # Distinct bundle id (com.tinycast.app.alpha) + app name, so alpha installs
  # side-by-side with the stable and beta casks.
  app "Tinycast Alpha.app"

  # Self-signed (not notarized): strip the quarantine flag on every install and upgrade
  # so Gatekeeper won't block launch — no manual xattr needed.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Tinycast Alpha.app"]
  end

  zap login_item: "Tinycast Alpha",
      trash: [
        "~/Library/Caches/com.tinycast.app.alpha",
        "~/Library/Preferences/com.tinycast.app.alpha.plist",
      ]

  caveats <<~EOS
    Tinycast Alpha is not signed or notarized. Homebrew clears the macOS quarantine
    flag for you automatically on install and every update, so there's nothing to run.
  EOS
end
