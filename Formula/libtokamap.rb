class Libtokamap < Formula
  desc "Library for flexible data mapping and transformation with multiple data sources"
  homepage "https://github.com/ukaea/libtokamap"
  url "https://github.com/ukaea/libtokamap/archive/refs/tags/0.2.0.tar.gz"
  sha256 "cbcf134f4afc9f09af17f975504109c905bdfe9ac9dc184a78c4f450be39a784"
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
