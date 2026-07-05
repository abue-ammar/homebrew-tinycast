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

  zap trash: [
    "~/Library/Caches/com.tinycast.app.alpha",
    "~/Library/Preferences/com.tinycast.app.alpha.plist",
  ]

  caveats <<~EOS
    Tinycast Alpha is not signed or notarized. macOS quarantines it on install;
    clear the flag once to open it:

      xattr -dr com.apple.quarantine "#{appdir}/Tinycast Alpha.app"
  EOS
end
