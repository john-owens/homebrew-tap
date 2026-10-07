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

## Publishing a new build

`scripts/release.sh 0.9.1-jo.2 feat/rosetta-nodes` (needs go, a logged-in gh, and a kiac checkout at `../kiac` or `$KIAC_DIR`). It builds darwin/arm64 the same way upstream does, publishes a pre-release on john-owens/kiac, verifies the uploaded hash, and bumps the cask.
