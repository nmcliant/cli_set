#!/usr/bin/env bash
set -euo pipefail

#=========================================================================
# すべてを 1 ファイルで賄うインストールスクリプトの例
#   - OS検出
#   - Nix インストール
#   - dotfilesクローン & シンボリックリンク
#   - Home Manager などによる設定反映
#   - GPGを用いた秘密ファイルの復号 (オプション)
#   - GitHub Actions などでのCIテストを想定したメモ
#
# ※ スクリプトを途中で細かく分割してもOK！
# ※ あくまでサンプルであり、必ずローカルでテストをしてください。
#=========================================================================

DOTFILES_REPO="https://github.com/your-account/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
PRIVATE_DIR="${DOTFILES_DIR}/private"

echo "===== 1. OS種類の判定 ====="

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    CYGWIN*)    OS=Cygwin;;
    MINGW*)     OS=MinGw;;
    *)          OS="UNKNOWN:${unameOut}"
esac

echo "Detected OS: ${OS}"

echo "===== 2. Nixのインストール (必要な場合) ====="
if ! command -v nix >/dev/null 2>&1; then
  echo "Nixが見つかりません。インストールします..."
  # Linux or macOS向けインストールスクリプト (公式)
  curl -L https://nixos.org/nix/install | sh
  # もし必要ならシェル初期化用スクリプトをsource
  # shellcheck disable=SC1091
  . ~/.nix-profile/etc/profile.d/nix.sh
else
  echo "Nixは既にインストールされています。"
fi

echo "===== 3. dotfiles リポジトリのクローン ====="
if [ -d "${DOTFILES_DIR}" ]; then
  echo "既に ${DOTFILES_DIR} が存在しています。更新を試みます..."
  cd "${DOTFILES_DIR}" && git pull && cd -
else
  echo "dotfilesをクローンします..."
  git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

echo "===== 4. シンボリックリンク作成 ====="
# 例: bashrc, vimrc, gitconfigなどをリンク
ln -sf "${DOTFILES_DIR}/.bashrc"       "${HOME}/.bashrc"
ln -sf "${DOTFILES_DIR}/.vimrc"        "${HOME}/.vimrc"
ln -sf "${DOTFILES_DIR}/.gitconfig"    "${HOME}/.gitconfig"

# OS依存の設定ファイルをリンクしたい場合
case "${OS}" in
  Linux)
    # Linux専用の設定
    if [ -f "${DOTFILES_DIR}/.bashrc_linux" ]; then
      ln -sf "${DOTFILES_DIR}/.bashrc_linux" "${HOME}/.bashrc_os_specific"
    fi
    ;;
  Mac)
    # macOS専用の設定
    if [ -f "${DOTFILES_DIR}/.bashrc_mac" ]; then
      ln -sf "${DOTFILES_DIR}/.bashrc_mac" "${HOME}/.bashrc_os_specific"
    fi
    ;;
esac

echo "===== 5. Home Manager (Nix) による構成適用 (オプション) ====="
# NixユーザならHome Managerを導入して設定を一括管理するのが便利です。
# ここではサンプル的に記載
if ! command -v home-manager >/dev/null 2>&1; then
  echo "Home Managerをインストールします..."
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
fi

# home.nix や flake.nix などがある場合
if [ -f "${DOTFILES_DIR}/home.nix" ]; then
  echo "Home Managerでユーザ環境を適用します..."
  home-manager switch --file "${DOTFILES_DIR}/home.nix"
fi
# flake.nixの場合は下記のようにも
# nix --experimental-features 'nix-command flakes' build ".#homeManagerConfigurations.${USER}.activationPackage"
# etc...

echo "===== 6. 秘密情報の管理 (オプション) ====="
# 機密ファイルをGPGで復号する例
if [ -f "${PRIVATE_DIR}/.gitconfig.private.gpg" ]; then
  echo "秘密情報を復号します。GPGパスフレーズが必要な場合があります..."
  gpg --decrypt "${PRIVATE_DIR}/.gitconfig.private.gpg" > "${HOME}/.gitconfig.private"
  # ここで .gitconfig.private を .gitconfig にincludeさせても良い
  # [include]
  #     path = ~/.gitconfig.private
fi

echo "===== 7. 最終確認 ====="
echo "OS: ${OS}"
echo "Nix: $(command -v nix || echo 'Not installed?')"
echo "ホームディレクトリにリンクが貼られました。必要に応じてログインシェルを再起動してください。"

echo "===== インストール完了！ ====="
echo "念のため、新しいシェルを開き直して設定が正しく読まれているか確認してください。"
