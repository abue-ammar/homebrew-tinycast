cask "tinycast@beta" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (beta channel). Run one beta Release to populate these.
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast Beta"
  desc "Minimal native macOS menu-bar launcher (beta channel)"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: ">= :tahoe"

  # Distinct bundle id (com.tinycast.app.beta) + app name, so beta installs
  # side-by-side with the stable and alpha casks.
  app "Tinycast Beta.app"

  zap trash: [
    "~/Library/Caches/com.tinycast.app.beta",
    "~/Library/Preferences/com.tinycast.app.beta.plist",
  ]

  caveats <<~EOS
    Tinycast Beta is not signed or notarized. macOS quarantines it on install;
    clear the flag once to open it:

      xattr -dr com.apple.quarantine "#{appdir}/Tinycast Beta.app"
  EOS
end
