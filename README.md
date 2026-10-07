# john-owens/homebrew-tap

Team test builds of [john-owens/kiac](https://github.com/john-owens/kiac), a fork of
[saiyam1814/kiac](https://github.com/saiyam1814/kiac).

```bash
brew uninstall --cask saiyam1814/tap/kiac 2>/dev/null   # only if you have upstream installed
brew install --cask john-owens/tap/kiac
kiac version && kiac doctor
```

Update: `brew update && brew upgrade --cask john-owens/tap/kiac`.
Back to upstream: `brew uninstall --cask john-owens/tap/kiac && brew install --cask saiyam1814/tap/kiac`.
