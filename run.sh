#! /bin/sh

# Offical homebrew mirrors
OFFICIAL_BREW="https://github.com/Homebrew/brew.git"
OFFICIAL_BREW_CORE="https://github.com/Homebrew/homebrew-core.git"
OFFICIAL_BREW_CASK="https://github.com/Homebrew/homebrew-cask.git"
OFFICIAL_BREW_CASK_FONT="https://github.com/Homebrew/homebrew-cask-fonts.git"

# Tencent Cloud homebrew mirros
# url: https://mirrors.cloud.tencent.com/
TENCENT_BREW="https://mirrors.cloud.tencent.com/homebrew/brew.git"
TENCENT_BREW_CORE="https://mirrors.cloud.tencent.com/homebrew/homebrew-core.git"
TENCENT_BREW_CASK="https://mirrors.cloud.tencent.com/homebrew/homebrew-cask.git"
TENCENT_BREW_CASK_FONT="https://mirrors.cloud.tencent.com/homebrew/homebrew-cask-fonts.git"
TENCENT_BOTTLE_DOMAIN="https://mirrors.cloud.tencent.com/homebrew-bottles"

# Pull parameter from CLI and uncaptalise it
MIRROR_TO_SET=$1
MIRROR_TO_SET="$(echo $MIRROR_TO_SET | tr '[:upper:]' '[:lower:]')"

# Change back to offical if no paratemer is passed
if [[ "$#" == 0 || "${MIRROR_TO_SET}" == "official" ]]; then
    git -C "$(brew --repo)" remote set-url origin "${OFFICIAL_BREW}"
    git -C "$(brew --repo)/Library/Taps/homebrew/homebrew-core" remote set-url origin "${OFFICIAL_BREW_CORE}"
    git -C "$(brew --repo)/Library/Taps/homebrew/homebrew-cask" remote set-url origin "${OFFICIAL_BREW_CASK}"  &> /dev/null
    git -C "$(brew --repo)/Library/Taps/homebrew/homebrew-cask-fonts" remote set-url origin "${OFFICIAL_BREW_CASK_FONT}" &> /dev/null
    sed -i.bak "/export HOMEBREW_BOTTLE_DOMAIN=/d" ~/.bash_profile
    echo "Successfully restored to the official brew git origin. "
    echo "The bottle domain will take effect once the terminal is reopened. "

# Change to Tencent Cloud mirrors
elif [[ "${MIRROR_TO_SET}" == "tencent" ]]; then
    git -C "$(brew --repo)" remote set-url origin "${TENCENT_BREW}"
    git -C "$(brew --repo)/Library/Taps/homebrew/homebrew-core" remote set-url origin "${TENCENT_BREW_CORE}"
    git -C "$(brew --repo)/Library/Taps/homebrew/homebrew-cask" remote set-url origin "${TENCENT_BREW_CASK}" &> /dev/null
    git -C "$(brew --repo)/Library/Taps/homebrew/homebrew-cask-fonts" remote set-url origin "${TENCENT_BREW_CASK_FONT}" &> /dev/null
    EXPORT_BOTTLE_STATEMENT="export HOMEBREW_BOTTLE_DOMAIN=${TENCENT_BOTTLE_DOMAIN}"
    if ! grep -Fxq "${EXPORT_BOTTLE_STATEMENT}" ~/.bash_profile ; then
        echo "${EXPORT_BOTTLE_STATEMENT}" >> ~/.bash_profile
    fi
    echo "Successfully set the brew git origin to ${MIRROR_TO_SET}. "
    echo "The bottle domain will take effect once the terminal is reopened. "

# Echo if the parameter is not recognised
else
    echo "${1} is not recognised. "
fi
