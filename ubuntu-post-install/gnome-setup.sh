#!/bin/bash

set -e

echo "GNOME Desktop Setup Starting..."

# 壁紙設定
WALLPAPER_URL="https://discourse.ubuntu.com/uploads/short-url/a6XsEwN9qsR1JSsOBLpSbqxaXMH.jpg?dl=1"
WALLPAPER_DIR="$HOME/.config/wallpapers"
WALLPAPER_FILE="$WALLPAPER_DIR/ubuntu-wallpaper.jpg"

echo "Setting up wallpaper..."
mkdir -p "$WALLPAPER_DIR"

if curl -L "$WALLPAPER_URL" -o "$WALLPAPER_FILE"; then
    echo "Wallpaper downloaded successfully"
    
    # ライト/ダークテーマ両方に設定
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_FILE"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_FILE"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    
    echo "Wallpaper set successfully"
else
    echo "Failed to download wallpaper"
fi

# トラックパッド設定
echo "Configuring trackpad..."

# タップでクリック無効化
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false

# ポインター速度を20%高速に（デフォルト0.0から0.2に）
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.2

echo "Trackpad configured successfully"

# その他のGNOME設定
echo "Configuring additional GNOME settings..."

# ディスプレイスケール設定
echo "Configuring display scaling..."

# セッションタイプを確認してfractional scaling有効化
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # Waylandの場合
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
else
    # X11の場合
    gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling']"
fi

echo "Fractional scaling enabled. Please set scale to 150% in Settings > Display after restart."

# フォント設定
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'

# 自動輝度調整を無効化
echo "Disabling automatic brightness adjustment..."
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

echo "Automatic brightness adjustment disabled"

# IME設定 (fcitx5をキーボード入力システムとして設定)
echo "Setting fcitx5 as keyboard input method system..."
im-config -n fcitx5

echo "fcitx5 set as input method system successfully"

# 時計の秒表示を有効化
echo "Enabling seconds in clock..."
gsettings set org.gnome.desktop.interface clock-show-seconds true

echo "Clock seconds enabled successfully"

# Dock設定 - 不要なアプリを削除
echo "Configuring dock favorites..."

# 現在のfavorite-appsを取得
CURRENT_FAVORITES=$(gsettings get org.gnome.shell favorite-apps)

# HelpとApp Centerを除外したリストを作成
NEW_FAVORITES=$(echo "$CURRENT_FAVORITES" | sed "s/'yelp.desktop', //g" | sed "s/, 'yelp.desktop'//g" | sed "s/'yelp.desktop'//g")
NEW_FAVORITES=$(echo "$NEW_FAVORITES" | sed "s/'snap-store_snap-store.desktop', //g" | sed "s/, 'snap-store_snap-store.desktop'//g" | sed "s/'snap-store_snap-store.desktop'//g")

# Terminalが含まれていない場合は追加
if [[ "$NEW_FAVORITES" != *"org.gnome.Terminal.desktop"* ]]; then
    # 最初の要素の後にTerminalを追加
    NEW_FAVORITES=$(echo "$NEW_FAVORITES" | sed "s/\['/['org.gnome.Terminal.desktop', '/")
fi

# VSCodeが含まれていない場合は追加
if [[ "$NEW_FAVORITES" != *"code.desktop"* ]]; then
    # リストの最後に追加
    NEW_FAVORITES=$(echo "$NEW_FAVORITES" | sed "s/]/, 'code.desktop']/")
fi

# NoMachineが含まれていない場合は追加
if [[ "$NEW_FAVORITES" != *"NoMachine-base.desktop"* ]]; then
    # リストの最後に追加
    NEW_FAVORITES=$(echo "$NEW_FAVORITES" | sed "s/]/, 'NoMachine-base.desktop']/")
fi

# 新しいfavorite-appsを設定
gsettings set org.gnome.shell favorite-apps "$NEW_FAVORITES"

echo "Dock favorites configured successfully"

echo "GNOME Desktop Setup Complete!"