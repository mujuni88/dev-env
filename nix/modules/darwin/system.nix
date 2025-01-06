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
      "/System/Applications/Calendar.app"
      "/Applications/Spark.app"
      "/System/Applications/Messages.app"
      "/Applications/Slack.app"
      "/Applications/Arc.app"
      "/Applications/Google Chrome.app"
      "/Applications/Notion.app"
      "/Applications/ChatGPT.app"
      "/Applications/Claude.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Windsurf.app"
      "/Applications/WezTerm.app"
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