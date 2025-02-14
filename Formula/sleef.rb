class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/3.5.0.tar.gz"
  sha256 "6b952560cec091477affcb18baf06bf50cef9f932ff6aba491a744ee8e77ffea"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git"

  bottle do
    cellar :any
    sha256 "c3aec292662ac506d6c8ccae2d6ea45019a5cbd9928b9c9bde35706410aac1c1" => :catalina
    sha256 "a9763b5dc87d218f416769cea9d1f349506dc37ccc102901840acb6667e9c3ec" => :mojave
    sha256 "ef3857646cb8e871f2a50f4f3e44e39debf6ef58cc43b3e82bb576fa0614f8ba" => :high_sierra
    sha256 "8e6caa35e7f758ff29924428fd53d275208f6a70caf71645638af846e536e3de" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI / 6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output("./test")
  end
end
