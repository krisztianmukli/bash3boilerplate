��    +      t  ;   �      �  -   �  _  �  "   G     j     |  =   �     �  \   �     =  )   U          �  H   �  &   �  0      3   Q  }   �  M   	  d   Q	  @   �	  A   �	  O   9
  e   �
  E   �
  9   5  Z   o     �  S   �  @   ;  ?   |     �  (   �  �   �  2   �     �     �  4     9   7  �   q  '      Z   H  1   �  �  �  S   �  �  �  $   �     �        F        X  n   t     �  5   �     -     F  _   ^  .   �  9   �  :   '  �   b  Z     i   f  Q   �  ?   "  V   b  o   �  R   )  >   |  w   �      3  P   T  G   �  N   �  
   <  +   G  �   s  ?   G     �     �  D   �  5     �   B  3   �  x   "  C   �     (            *                                 '          	                                               
          )      %                     +              &          "      !   #                $    Assuming local install, trying to user's PATH Available arguments:

  -s --script [scriptfile] Remove specified scriptfile and it's localization and payloads. Required.
  -l --with-libraries      Remove specified scriptfile and it's libraries, if any
  -D --with-dependencies   Remove specified scriptfile and it's dependencies
  -d --debug               Enables debug mode
  -f --force               Force remove commands
  -h --help                This page
  -n --no-color            Disable color output
  -v                       Enable verbose mode, print script as it is executed
  -V --version             Display version and license information Cannot continue without LOG_LEVEL. Cleaning up. Done Default Error in ${__sr_file} in function ${function} on line ${line} Finished the package-removing For removing following packages in macOS, you must use Homebrew or Macports: ${dependencies} Help using ${__sr_base} Invalid use of script: ${__sr_tmp_params} Licensed under the MIT license No valid packages Option -${__sr_tmp_opt_short}${__sr_tmp_opt_long:-} requires an argument Removing dependencies: ${dependencies} Removing file ${targetdir}/${script} was success Removing file ${targetdir}/lib/${lib} was succesful Removing following packages from shell in cygwin, must be use apt-cyg, or install them with Cygwin setup.exe: ${dependencies} Removing libraries was unsuccessful: there was an error during removing files Removing libraries was unsuccessful: there was an error during removing files ${libtargetdir}/${lib} Removing libraries was unsuccessful: unsupported filename ($lib) Removing of following dependencies was succesful: ${dependencies} Removing packages unsuccessful: there was an error during removing dependencies Removing payloads was unsuccessful: there was an error during removing files: ${targetdir}/${payload} Removing payloads was unsuccessful: unsupported filename (${payload}) Removing script unsuccessful: ${targetdir} is not exists! Removing script unsuccessful: ${targetdir} is not writable! It may need higher privileges. Removing script was success. Removing script was unsuccessful: there was an error during removing file ${script} Removing script was unsuccessful: unsupported filename ($script) Removing unsuccessful: there was an error during removing files Required Script is unavailable or doesn't exists! Script use the following packages as dependencies: ${dependencies}.\nWould you like to remove them? It can effect to other softwares, don't do it if you don't understand! Setting a filename with -s or --source is required Standalone script uninstaller Starting package-remove Targetdir, where installed script were: ${targetdir} The file ${sourcedir}/${payload} was succesfully removed. This command can uninstall bash-script and it's dependencies from a specified
 folder, using script own ini file. 
 It is part of BASH3 Boilerplate by krisztianmukli project. Unknown error during removing packages! Unknown or unsupported operating system, cannot remove following packages: ${dependencies} You need higher privileges for removing packages! Project-Id-Version: BASH3 Boilerplate by krisztianmukli
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2018-06-25 14:07+0200
Last-Translator: Mukli Krisztián <krisztianmukli@mukli.hu>
Language-Team: Mukli Krisztián <krisztianmukli@mukli.hu>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
X-Generator: Poedit 2.0.6
X-Poedit-SourceCharset: UTF-8
 Helyi telepítés feltételezése, a felhasználó PATH változójának használata Használható argumentumok:

  -s --script [scriptfile] Eltávolítja a megadott szkriptfájlt, a lokalizációs fájljait és csatolt fájljait. Kötelező.
  -l --with-libraries      Programkönyvtáraival együtt távolítja el a megadott szkriptfájlt.
  -D --with-dependencies   Függőségeivel együtt távolítja el a megadott szkriptfájlt
  -d --debug               Hibakeresési mód engedélyezése
  -f --force               Eltávolítási utasítások erőltetése
  -h --help                Súgó
  -n --no-color            Színes kimenet kikapcsolása
  -v                       Részletes mód engedélyezése, kiíratja a szkriptet futás közben
  -V --version             Verzió és licencinformációk megjelenítése Nem folytatható LOG_LEVEL nélkül. Takarítás. Kész Alapértelmezett Hiba a ${__sr_file} fájl ${function} funkciójában a ${line}. sorban Csomag-eltávolítás kész A következő csomagok eltávolításához macOS alatt a HomeBrew vagy a Macports szükséges: ${dependencies} ${__sr_base} súgó Szkript érvénytelen használata: ${__sr_tmp_params} MIT licensz alatt kiadva Nincs érvényes csomag A(z) -${__sr_tmp_opt_short}${__sr_tmp_opt_long:-} kapcsolónak argumentum megadása szükséges Függőségek eltávolítása: ${dependencies} A(z) ${targetdir}/${script} fájl eltávolítása sikeres A(z) ${targetdir}/lib/${lib} fájl eltávolítása sikeres A következő csomagok eltávolításához a rendszerhéjból cygwin alatt, szükség van az apt-cyg parancsra, vagy használja a Cygwin setup.exe-jét: ${dependencies} Programkönyvtárak eltávolítása sikertelen: hiba történt a fájlok törlése közben Programkönyvtárak eltávolítása sikertelen: hiba történ a ${libtargetdir}/${lib} fájl törlésekor Programkönyvtárak eltávolítása sikertelen: nem támogatott fájlnév: ($lib) A következő csomagok eltávolítása sikeres: ${dependencies} Csomagok eltávolítása sikertelen: hiba történt a csomagok eltávolítása közben Csatolt fájlok eltávolítása sikertelen: hiba történt a fájlok törlése közben: ${targetdir}/${payload} Csatolt fájlok eltávolítása sikertelen: nem támogatott fájlnév (${payload}) Szkript eltávolítása sikertelen: ${targetdir} nem létezik! Szkript eltávolítása sikertelen: ${targetdir} nem írható! Lehetséges, hogy magasabb jogosultságok szükségesek. Szkript eltávolítása sikeres. Szkript eltávolítása sikertelen: hiba történt a ${script} törlése közben Szkript eltávolítása sikertelen: nem támogatott fájlnév ($script) Szkript eltávolítása sikertelen: hiba történt a fájlok törlése közben Kötelező A szkript nem elérhető vagy nem létezik! A megadott szkript a következő csomagokat használja függőségként: ${dependencies}.\nSzeretné eltávolítani őket? Ez hatással lehet más szoftverek működésére is, ne tegye ha nem tudja mit csinál! Fájlnév megadása a -s vagy --source kapcsolóval szükséges Önálló szkript eltávolító Csomageltávolítás indítása Célkönyvtár, ahol a telepített szkript található: ${targetdir} A(z) ${sourcedir}/${payload} sikeresen eltávolítva. Eltávolítja a megadott szkriptet és függőségeit a megadott mappából, annak saját .ini-fájlját használva.
 A BASH3 Boilerplate by krisztianmukli projekt része. Ismeretlen hiba a csomagok eltávolítása közben! Ismeretlen vagy nem támogatott operációs rendszer, nem lehet eltávolítani a következő csomagokat: ${dependencies} Magasabb jogosultságokra van szükség a csomag-eltávolításhoz! 