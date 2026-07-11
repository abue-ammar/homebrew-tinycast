cask "tinycast@alpha" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (alpha channel). Run one alpha Release to populate these.
  version "0.3.4-alpha.13"
  sha256 "67691010018e8520ade9a339fa3b97c85b6689559b8c0a7eca05d4dfc1fab26f"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast Alpha"
  desc "Tinycast — A tiny, fully native macOS launcher, hotkeys, and clipboard history (alpha channel)"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: ">= :tahoe"

  # Distinct bundle id (com.tinycast.app.alpha) + app name, so alpha installs
  # side-by-side with the stable and beta casks.
  app "Tinycast Alpha.app"

  zap login_item: "Tinycast Alpha",
      trash: [
        "~/Library/Caches/com.tinycast.app.alpha",
        "~/Library/Preferences/com.tinycast.app.alpha.plist",
      ]

  caveats <<~EOS
    Tinycast Alpha is not signed or notarized. macOS quarantines it on install;
    clear the flag once to open it:

      xattr -dr com.apple.quarantine "#{appdir}/Tinycast Alpha.app"
  EOS
end
