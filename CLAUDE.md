# Ubuntu Configuration Management

## 概要

Ubuntu AutoInstall/Subiquityを使用してシステム構成を管理するプロジェクト。
メンテナブルな自動化構成の確立が目標。

## ファイル構成

### mb2017.yaml
- Ubuntu AutoInstallの設定ファイル
- システムの基本構成を定義
  - ホスト名: mb2017
  - ユーザー: muo
  - タイムゾーン: Asia/Tokyo
  - パッケージ: vim, tmux, git, net-tools, virt-manager, curl, wireguard-tools, fcitx5-mozc
  - ストレージ構成: NVMe SSDのパーティション設定

### envconf.sh
- 個人環境設定用スクリプト（sudo権限必要な設定）
- 現在の機能:
  - Node.js (nvm) セットアップ
  - @anthropic-ai/claude-code インストール
  - uv (Python package manager) インストール
  - GNOME設定スクリプトの実行
  - Firefox Bitwarden拡張機能の自動インストール設定
  - VSCode インストール (公式debパッケージ)
  - NoMachine インストール (公式debパッケージ)

### gnome-setup.sh
- GNOMEデスクトップ環境の設定スクリプト
- リモートから取得・実行される (https://muojp.github.io/conf/gnome-setup.sh)
- 主な機能:
  - 壁紙設定 (指定URIから自動取得・設定)
  - トラックパッド設定 (タップ無効化、ポインター速度調整)
  - Fractional scaling有効化 (手動で150%設定が必要)
  - 自動輝度調整無効化
  - Dock設定 (Help・App Center削除、Terminal・VSCode・NoMachine追加)
  - フォント設定

### firefox-post-install.sh
- Firefox個人設定用スクリプト（ユーザー権限のみ）
- 主な機能:
  - Sponsored content・ショートカット無効化
  - Top Sites (YouTube等デフォルトショートカット) 削除
  - Pocket無効化
  - プライバシー設定強化
  - 既存設定のクリーンアップ

## 設定の役割分担

### システムレベル (sudo権限必要)
- **mb2017.yaml**: OSインストール時の基本設定
- **envconf.sh**: アプリケーションインストール、システム設定

### ユーザーレベル
- **gnome-setup.sh**: デスクトップ環境設定 (gsettings)
- **firefox-post-install.sh**: Firefoxユーザープロファイル設定

## 実装済み機能

### GNOMEデスクトップ設定 ✅
- 壁紙自動設定
- トラックパッド最適化
- Fractional scaling対応
- Dockカスタマイズ
- 不要機能無効化

### アプリケーション管理 ✅
- 基本パッケージ (AutoInstall)
- 開発環境 (Node.js, Python, VSCode)
- リモートアクセス (NoMachine)
- ブラウザ拡張 (Bitwarden)
- 日本語入力 (fcitx5-mozc)

### 設定の自動化 ✅
- dconf/gsettingsベースの設定管理
- Firefox policies.json活用
- リモートスクリプト実行による柔軟な更新

## 今後の拡張

- 追加アプリケーションの設定自動化
- 設定値の外部ファイル化
- エラーハンドリングの強化