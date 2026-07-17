cask "tinycast@alpha" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (alpha channel). Run one alpha Release to populate these.
  version "0.5.7-alpha.22"
  sha256 "1f65878e8645ce5617023258fd1fdbffd065e623faf0e880be30c8c92f75fd69"

  url "https://github.com/abue-ammar/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg",
      verified: "github.com/abue-ammar/tinycast/"
  name "Tinycast Alpha"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history (alpha channel)"
  homepage "https://github.com/abue-ammar/tinycast"

  depends_on macos: :tahoe

  # Distinct bundle id (com.tinycast.app.alpha) + app name, so alpha installs
  # side-by-side with the stable and beta casks.
  app "Tinycast Alpha.app"

  # Self-signed (not notarized): strip the quarantine flag on every install and upgrade
  # so Gatekeeper won't block launch — no manual xattr needed. Then relaunch in the
  # background so an upgrade lands the user back in a running app.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Tinycast Alpha.app"]
    system_command "/usr/bin/open",
                   args: ["-g", "#{appdir}/Tinycast Alpha.app"]
  end

  # Quit the running app before Homebrew replaces the bundle on upgrade/uninstall.
  uninstall quit: "com.tinycast.app.alpha"

  zap login_item: "Tinycast Alpha",
      trash:      [
        "~/Library/Application Support/com.tinycast.app.alpha",
        "~/Library/Caches/com.tinycast.app.alpha",
        "~/Library/Preferences/com.tinycast.app.alpha.plist",
        "~/Library/Saved Application State/com.tinycast.app.alpha.savedState",
      ]

  caveats <<~EOS
    Tinycast Alpha is not signed or notarized. Homebrew clears the macOS quarantine
    flag for you automatically on install and every update, so there's nothing to run.
    Upgrading via `brew` quits and relaunches Tinycast Alpha for you.
  EOS
end
