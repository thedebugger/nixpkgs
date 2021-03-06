{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

let version = "2.0"; in
stdenv.mkDerivation {
  name = "remotebox-${version}";

  src = fetchurl {
    url = "http://remotebox.knobgoblin.org.uk/downloads/RemoteBox-${version}.tar.bz2";
    sha256 = "0c73i53wdjd2m2sdgq3r3xp30irxh5z5rak2rk79yb686s6bv759";
  };

  buildInputs = with perlPackages; [ perl Glib Gtk2 Pango SOAPLite ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/bin

    substituteInPlace remotebox --replace "\$Bin/" "\$Bin/../"
    install -v -t $out/bin remotebox
    wrapProgram $out/bin/remotebox --prefix PERL5LIB : $PERL5LIB

    cp -av docs/ share/ $out

    mkdir -pv $out/share/applications
    cp -pv packagers-readme/*.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "VirtualBox client with remote management";
    homepage = http://remotebox.knobgoblin.org.uk/;
    license = licenses.gpl2Plus;
    longDescription = ''
      VirtualBox is traditionally considered to be a virtualization solution
      aimed at the desktop. While it is certainly possible to install
      VirtualBox on a server, it offers few remote management features beyond
      using the vboxmanage command line.
      RemoteBox aims to fill this gap by providing a graphical VirtualBox
      client which is able to manage a VirtualBox server installation.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.all;
  };
}
