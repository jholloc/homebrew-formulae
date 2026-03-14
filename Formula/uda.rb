class Uda < Formula
  desc "Universal Data Access library to provide data over the network in a unified data object"
  homepage "https://github.com/ukaea/uda"
  url "https://github.com/ukaea/uda/archive/refs/tags/2.9.3.tar.gz"
  sha256 "c3627ebac5bf5cd10c25cbf79bc4c2adb33989c3860810f0512c4f15ad77e84e"
  license "Apache-2.0"
  head "https://github.com/ukaea/uda.git", branch: "main"

  depends_on "git" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "libxml2"
  depends_on "spdlog"
  depends_on "capnp"
  depends_on macos: :catalina

  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <c++/UDA.hpp>
      #include <iostream>

      int main() {
          uda::Client client;
          std::cout << "UDA loaded successfully" << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++20", "test.cpp",
                    "-I#{include}/uda",
                    "-L#{lib}",
                    "-luda_cpp",
                    "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/test/CMakeLists.txt b/test/CMakeLists.txt
index 0cbade34..9a8f2bae 100755
--- a/test/CMakeLists.txt
+++ b/test/CMakeLists.txt
@@ -159,7 +159,7 @@ endmacro( BUILD_TEST )

 add_subdirectory( plugins )
 # add_subdirectory( imas )
-add_subdirectory( unit_tests )
+# add_subdirectory( unit_test )

 add_definitions( -D__USE_XOPEN2K8 )
