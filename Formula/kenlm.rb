class Kenlm < Formula
  desc "Faster and Smaller Language Model Queries"
  homepage "https://kheafield.com/code/kenlm/"
  license "LGPL-2.1-only"
  head "https://github.com/kpu/kenlm.git"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "libomp"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    mv "bin", prefix
    mv "lib", prefix
  end

  test do
    system "false"
  end
end
