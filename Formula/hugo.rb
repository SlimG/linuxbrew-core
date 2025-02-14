class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.75.0.tar.gz"
  sha256 "d0748cdc03e87d522434f21470d6f40f0d8d4cc1075ae971678450043bf78d34"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcff812c6b91c4c879c00bea6849bc0eaf1da408cfe3476ae8606e219d49ba4a" => :catalina
    sha256 "ab6e90f361d53e01516ff0282b199447acbe7291921ce6acee9275b00136a73d" => :mojave
    sha256 "0ef2cb85d4c6195dae8b3c9859c2853ea08a14e0c5061b4b5f0b69bcfaee0766" => :high_sierra
    sha256 "95abd7d820a9aa439e1818ee3297d806cdbab61d06896f9fda37483ddf8b23f1" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
