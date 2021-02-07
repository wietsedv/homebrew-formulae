class CalibreCli < Formula
  desc "E-books management software"
  homepage "https://calibre-ebook.com/"
  url "https://github.com/kovidgoyal/calibre/releases/download/v#{version}/calibre-#{version}-x86_64.txz"
  version "5.10.1"
  sha256 "9276116a05bda85e7ff95499598cf2161d5169ca37f6633e52f976d310e436e0"
  license "GPL-3.0-only"

  depends_on "patchelf" => :build
  depends_on "bzip2"
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "webp"
  depends_on "zlib"

  def install
    lib.mkpath
    mkdir lib/"calibre-extensions"
    Dir.glob("lib/calibre-extensions/*") do |l|
      next if /PyQt5|imageops\.so|libheadless\.so|pictureflow\.so|progress_indicator\.so/.match?(l)

      system "patchelf", "--set-rpath", "#{HOMEBREW_PREFIX}/lib", l if l.end_with?(".so")
      mv l, lib/"calibre-extensions"
    end
    ["libcalibre-launcher.so", "libpython3.8.so.1.0", "libicui18n.so.67", "libicuuc.so.67",
     "libicudata.so.67", "libchm.so.0"].each do |l|
      system "patchelf", "--set-rpath", "#{HOMEBREW_PREFIX}/lib", "lib/#{l}"
      lib.install "lib/#{l}"
    end

    bin.mkpath
    ["ebook-convert"].each do |b|
      system "patchelf", "--set-rpath", "#{HOMEBREW_PREFIX}/lib", "bin/#{b}"
      bin.install "bin/#{b}"
    end

    mv "resources", prefix
  end

  test do
    system bin/"ebook-convert", "--help"
  end
end
