{
  c3c-src,
  c3c-ver,
  llvmPackages,
  lib,
  cmake,
  python3,
  curl,
  libxml2,
  libffi,
  xar,
  versionCheckHook,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "c3c";
  # Get short rev for version (first 7 letters of commit)
  # version = "commit-${lib.concatImapStrings (i: x: if i <= 7 then x else "") (lib.stringToCharacters c3c-repo.rev)}";
  version = "${c3c-ver}";

  src = c3c-src;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${LLVM_LIBRARY_DIRS}" "${llvmPackages.lld.lib}/lib ${llvmPackages.llvm.lib}/lib"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    curl
    libxml2
    libffi
  ] ++ lib.optionals llvmPackages.stdenv.hostPlatform.isDarwin [ xar ];

  nativeCheckInputs = [ python3 ];

  doCheck = llvmPackages.stdenv.system == "x86_64-linux";

  checkPhase = ''
    runHook preCheck
    ( cd ../resources/testproject; ../../build/c3c build )
    ( cd ../test; python src/tester.py ../build/c3c test_suite )
    runHook postCheck
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Compiler for the C3 language";
    homepage = "https://github.com/c3lang/c3c";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      luc65r
      anas
    ];
    platforms = platforms.all;
    mainProgram = "c3c";
  };
})
