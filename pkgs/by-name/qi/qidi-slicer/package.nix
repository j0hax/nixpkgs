{
  catch2,
  gtk3,
  nanosvg,
  expat,
  wxGTK32,
  opencascade-occt_7_6,
  mpfr,
  libjpeg,
  gmp,
  cgal,
  libbgcode,
  heatshrink,
  qhull,
  fetchFromGitHub,
  pkg-config,
  ilmbase,
  cereal,
  tbb_2021_11,
  nlopt,
  libpng,
  openvdb,
  curl,
  boost,
  glew,
  dbus,
  lib,
  stdenv,
  cmake,
  wrapGAppsHook,

  # New
  webkitgtk_4_1,
  libsoup_3,

  fetchurl,

  # Extra Deps
  eigen,
#glib,
#hicolor-icon-theme,
#pcre,
#xorg,
}:
let
  wxGTK-prusa = wxGTK32.overrideAttrs (old: rec {
    pname = "wxwidgets-prusa3d-patched";
    #version = "3.2.0";
    configureFlags = old.configureFlags ++ [ "--disable-glcanvasegl" ];
    #patches = [ ./webview.patch ];
    src = fetchFromGitHub {
      owner = "prusa3d";
      repo = "wxWidgets";
      rev = "323a465e577e03f330e2e6a4c78e564d125340cb";
      hash = "sha256-tVhBnO+A9aN5HwExgPDsccvOCnsJrG0qdPKpPmdtBzc=";
      fetchSubmodules = true;
    };
    #buildInputs = old.buildInputs ++ [ curl ];
  });

  nanosvg-fltk = nanosvg.overrideAttrs (old: rec {
    pname = "nanosvg-fltk";
    version = "unstable-2022-12-22";
    src = fetchFromGitHub {
      owner = "fltk";
      repo = "nanosvg";
      rev = "abcd277ea45e9098bed752cf9c6875b533c0892f";
      hash = "sha256-WNdAYu66ggpSYJ8Kt57yEA4mSTv+Rvzj9Rm1q765HpY=";
    };
  });

  opencascade-occt_7_6_1 = opencascade-occt_7_6.overrideAttrs (old: rec {
    version = "7.6.1";
    commit = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";
    src = fetchurl {
      name = "occt-${commit}.tar.gz";
      url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
      hash = "sha256-PZVrLSbR7nWsArIeg47YtHMdnpFAHK5K80VbVrAA9W0=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qidi-slicer";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "QIDITECH";
    repo = "QIDISlicer";
    rev = "V${finalAttrs.version}";
    hash = "sha256-jnrihGpYH8tnvn1syiv+JJUzqcJX6LSU0b/voFv31n8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    nanosvg-fltk
    expat
    ilmbase
    boost
    qhull
    cereal
    libbgcode
    heatshrink
    curl
    gmp
    cgal
    dbus
    glew
    catch2
    nlopt
    opencascade-occt_7_6_1
    libjpeg
    mpfr
    openvdb
    libpng
    tbb_2021_11

    webkitgtk_4_1
    libsoup_3

    wxGTK-prusa
    eigen
    #glib
    #hicolor-icon-theme
    #pcre
    #xorg.libX11
  ];

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
    "-DSLIC3R_PCH=OFF"
  ];

  prePatch = ''
    # Disable slic3r_jobs_tests.cpp as the test fails sometimes
    sed -i 's|slic3r_jobs_tests.cpp||g' tests/slic3rutils/CMakeLists.txt
    # https://github.com/prusa3d/PrusaSlicer/issues/9581
    if [ -f "cmake/modules/FindEXPAT.cmake" ]; then
      rm cmake/modules/FindEXPAT.cmake
    fi
  '';

  meta = {
    description = "Slicer for QIDI 3D Printers, based on PrusaSlicer";
    longDescription = ''
      QIDISlicer is a 3D printer slicing software that works with all QIDI Technology printers and filaments.
      It is easy to use and has all the functions you need to learn 3D printing.
    '';
    homepage = "https://github.com/QIDITECH/QIDISlicer";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ j0hax ];
    mainProgram = "qidi-slicer";
    platforms = [ "x86_64-linux" ];
  };
})
