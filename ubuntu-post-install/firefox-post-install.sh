#!/bin/bash

set -e

echo "Firefox Post-Install Configuration Starting..."

# Firefox プロファイルディレクトリを探す
FIREFOX_PROFILE_DIR=""

# Snap版Firefoxのプロファイルディレクトリをチェック
if [ -d "$HOME/snap/firefox/common/.mozilla/firefox" ]; then
    FIREFOX_PROFILE_DIR=$(find "$HOME/snap/firefox/common/.mozilla/firefox" -name "*.default" -type d | head -1)
    if [ -z "$FIREFOX_PROFILE_DIR" ]; then
        FIREFOX_PROFILE_DIR=$(find "$HOME/snap/firefox/common/.mozilla/firefox" -name "*.default-release" -type d | head -1)
    fi
fi

# 通常版Firefoxのプロファイルディレクトリをチェック（Snap版が見つからない場合）
if [ -z "$FIREFOX_PROFILE_DIR" ] && [ -d "$HOME/.mozilla/firefox" ]; then
    FIREFOX_PROFILE_DIR=$(find "$HOME/.mozilla/firefox" -name "*.default-release" -type d | head -1)
    if [ -z "$FIREFOX_PROFILE_DIR" ]; then
        FIREFOX_PROFILE_DIR=$(find "$HOME/.mozilla/firefox" -name "*.default" -type d | head -1)
    fi
fi

if [ -z "$FIREFOX_PROFILE_DIR" ]; then
    echo "Firefox profile directory not found. Please run Firefox once first."
    echo "Checked locations:"
    echo "  - $HOME/snap/firefox/common/.mozilla/firefox (Snap version)"
    echo "  - $HOME/.mozilla/firefox (Standard version)"
    exit 1
fi

echo "Firefox profile found: $FIREFOX_PROFILE_DIR"

# user.js ファイルを作成/更新
USER_JS_FILE="$FIREFOX_PROFILE_DIR/user.js"

echo "Configuring Firefox user preferences..."

# user.js にプリファレンスを追加
cat >> "$USER_JS_FILE" << 'EOF'
// Firefox Post-Install Configuration

// New Tab Page - Sponsored content を無効化
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Top Sites (ショートカット) を無効化
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", true);

// Pocket を無効化
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("extensions.pocket.enabled", false);

// その他の不要な機能を無効化
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// プライバシー強化
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);

// デフォルトブックマークツールバーの不要なものを非表示
user_pref("browser.toolbars.bookmarks.visibility", "always");

EOF

echo "User preferences configured successfully"

# 既存のTopSitesを削除（既に存在する場合）
PREFS_JS_FILE="$FIREFOX_PROFILE_DIR/prefs.js"

if [ -f "$PREFS_JS_FILE" ]; then
    echo "Cleaning existing sponsored shortcuts..."
    
    # Firefox が動作中でない場合のみ実行
    if ! pgrep -x "firefox" > /dev/null; then
        # TopSites関連の設定を削除
        sed -i '/browser\.newtabpage\.pinned/d' "$PREFS_JS_FILE"
        sed -i '/browser\.newtabpage\.activity-stream\.default\.sites/d' "$PREFS_JS_FILE"
        echo "Existing shortcuts cleaned"
    else
        echo "Firefox is running. Please close Firefox and run this script again to clean existing shortcuts."
    fi
fi

echo "Firefox Post-Install Configuration Complete!"
echo "Please restart Firefox to apply all changes."