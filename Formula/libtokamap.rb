class Libtokamap < Formula
  desc "Library for flexible data mapping and transformation with multiple data sources"
  homepage "https://github.com/ukaea/libtokamap"
  url "https://github.com/ukaea/libtokamap/archive/refs/tags/0.2.1.tar.gz"
  sha256 "17f159bc5b4b133f726ca67c96f1bf6546b3b1c7911cd7e503155f75ea74fb44"
  license "MIT"
  head "https://github.com/ukaea/libtokamap.git", branch: "main"

  depends_on "cmake" => :build
  depends_on macos: :catalina

  # All required dependencies are bundled in ext_include/
  # Including: nlohmann/json, inja, exprtk, spdlog, valijson, ctre, toml

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DENABLE_TESTING=OFF",
                    "-DENABLE_EXAMPLES=OFF",
                    "-DENABLE_PROFILING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libtokamap.hpp>
      #include <iostream>

      int main() {
          libtokamap::MappingHandler mapping_handler;
          std::cout << "LibTokaMap loaded successfully" << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++20", "test.cpp",
                    "-I#{include}/libtokamap",
                    "-L#{lib}",
                    "-ltokamap",
                    "-o", "test"
    system "./test"
  end
end
