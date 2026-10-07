cask "kiac" do
  postflight_steps do
    on_macos do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}/kiac"]
    end
  end

  version "0.9.1-jo.1"

  on_macos do
    on_arm do
      sha256 "7e6d99c6dc35cfb5cb9bba51f40cce327343d6bb8d8a1ed6a29ed9e9133c9a64"
      url "https://github.com/john-owens/kiac/releases/download/v#{version}/kiac_#{version}_darwin_arm64.tar.gz"
    end
  end

  name "kiac"
  desc "Kubernetes in Apple Containers - team test build with Rosetta, CA trust and registry cache"
  homepage "https://github.com/john-owens/kiac"

  livecheck do
    skip "Team test builds are published by hand."
  end
  depends_on formula: [
      "kubernetes-cli",
    ]

  binary "kiac"

  caveats <<~EOS
    Team test build of john-owens/kiac (upstream: saiyam1814/kiac).
    kiac needs apple/container 1.0+ (1.4.1 recommended; skip 1.2.0):
      https://github.com/apple/container/releases
    Then: kiac doctor
    New options: --rosetta, --ca-cert, --registry-cache, kiac cache
  EOS
end
