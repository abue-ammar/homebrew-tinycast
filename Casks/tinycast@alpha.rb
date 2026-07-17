cask "tinycast@alpha" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (alpha channel). Run one alpha Release to populate these.
  version "0.3.0-alpha.9"
  sha256 "48ce1eff5f54d6cd84b9a36bf351d58c60303579964d84c76a448c92ddfe90a0"

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
