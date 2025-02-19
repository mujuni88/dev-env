{
  # Dock settings
  dock = {
    autohide = true;
    orientation = "bottom";
    show-recents = false;
    launchanim = true;
    tilesize = 48;
    persistent-apps = [
      "/System/Applications/iPhone Mirroring.app"
      "/Users/jbuza/Applications/AppCleaner.app"
      "/Applications/Spark.app"
      "/System/Applications/Calendar.app"
      "/System/Applications/Messages.app"
      "/Users/jbuza/Applications/Slack.app"
      "/Users/jbuza/Applications/Arc.app"
      "/Users/jbuza/Applications/Notion.app"
      "/Users/jbuza/Applications/ChatGPT.app"
      "/Users/jbuza/Applications/Claude.app"
      "/Users/jbuza/Applications/Windsurf.app"
      "/Applications/Cursor.app"
      "/Users/jbuza/Applications/Ghostty.app"
      "/Users/jbuza/Applications/Warp.app"
    ];
  };

  # Finder settings
  finder = {
    AppleShowAllExtensions = true;
    ShowPathbar = true;
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "clmv";
  };

  # Screensaver settings
  screensaver = {
    askForPasswordDelay = 10;
  };

  # Global macOS settings
  NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    KeyRepeat = 3;
  };
}