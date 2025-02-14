class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.36/at-spi2-core-2.36.1.tar.xz"
  sha256 "97417b909dbbf000e7b21062a13b2f1fd52a336f5a53925bb26d27b65ace6c54"

  bottle do
    sha256 "6d331646213493b0a333d04e7bb372e6b962e8789ad168cd87d6b6f5054436a6" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"
  depends_on :linux
  depends_on "linuxbrew/xorg/libx11"
  depends_on "linuxbrew/xorg/libxtst"
  depends_on "linuxbrew/xorg/xorgproto"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
