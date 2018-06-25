��    3      �  G   L      h  �  i  "   H     k     }  (   �  =   �  !   �  O     ]   ^     �     �  �   �     �	  9   	
  9   C
  0   }
  D   �
  9   �
  7   -  :   e  6   �  4   �  9     <   F  6   �  B   �  L   �  6   J  <   �  ;   �  )   �     $  $   C     h  H   z     �  l   �     9     R     n  /   �  :   �  E   �  �   =  )   �  Z     ;   l  "   �  3   �  f   �  �  f  K    $   j     �     �  -   �  F   �     (  P   @  j   �     �         &  �   -  >   �  >     7   T  @   �  5   �  4     8   8  2   q  1   �  J   �  M   !  G   o  C   �  J   �  8   F  >     =   �  5   �     2  '   K     s  _   �  
   �  �   �     {      �      �   8   �   B   	!  P   L!  �   �!  *   2"  t   ]"  D   �"  )   #  D   A#  �   �#     +                  	           #          .         )                           
       -   &   2      "          '                      !   ,      *   %         $   3         (                            /                       0          1            Available arguments:

  -c --check-dependencies  Check dependencies of specified script
  -d --debug               Enables debug mode
  -f --force               Forcing commands (e.g. overwrite existing files)
  -h --help                This page
  -i --ini [inifile]       Ini-file using the installation. If not set, installer use [sourcedir]/install.ini
  -n --no-color            Disable color output
  -s --source [sourcedir]  Source dir of script. Default="$(pwd)"
  -t --target [targetdir]  Target directory. Optional, if not specified, installer use /usr/local/bin or ~/.local/bin
  -v                       Enable verbose mode, print script as it is executed
  -V --version             Display version and license information Cannot continue without LOG_LEVEL. Cleaning up. Done Default Defined target dir: ${defined_targetdir} Error in ${__si_file} in function ${function} on line ${line} Finished the package-installation Following packages are missing: ${missingpkgs}, would you like to install them? For installing following packages in macOS, you must use Homebrew or Macports: ${missingpkgs} Help using ${__si_base} Ini-file: ${inifile} Install script manually: 
    * Copy the script and the lib folder to your PATH.
    * Copy to locale folder to your locale folder.
    * Install dependencies. Install the following packages from shell in cygwin, must be use apt-cyg, or install them with Cygwin setup.exe: ${missingpkgs} Installation file ${lib} was succesful to ${libtargetdir} Installation file ${script} was succesful to ${targetdir} Installation files was succesful to ${targetdir} Installation of following dependencies was succesful: ${missingpkgs} Installation unsuccessful: ${libsourcedir} is not exists! Installation unsuccessful: ${libtargetdir} not writable Installation unsuccessful: ${localetargetdir} not writable Installation unsuccessful: ${sourcedir} is not exists! Installation unsuccessful: ${targetdir} not writable Installation unsuccessful: can not create ${libtargetdir} Installation unsuccessful: can not create ${localetargetdir} Installation unsuccessful: can not create ${targetdir} Installation unsuccessful: there was an error during copying files Installation unsuccessful: there was an error during installing dependencies Installation unsuccessful: unsupported filename ($lib) Installation unsuccessful: unsupported filename (${payload}) Installation unsuccessful: unsupported filename (${script}) Invalid use of script: ${__si_tmp_params} Licensed under the MIT license Missing dependencies: ${missingpkgs} No valid packages Option -${__si_tmp_opt_short}${__si_tmp_opt_long:-} requires an argument Required Set executable permission was unsuccessful for file ${targetdir}/${script}! Maybe it need higher privileges! Source dir: ${sourcedir} Standalone script installer Starting package-installation Target directory for locale files: ${localedir} Target directory, to the script will install: ${targetdir} Target directory, which is added to ~/.profile file: ${targetdirtext} This command can install bash-script and it's dependencies from a specified
 folder, using install.ini file. 
 It is part of BASH3 Boilerplate by krisztianmukli project. Unknown error during installing packages! Unknown or unsupported operating system, cannot install following packages: ${missingpkgs} Unsupported operating system. Installation is not possible. User's home dir: ${__si_user_home} You need higher privileges for installing packages! ~/.profile was updated, please login again or run 'source ~/.profile' command to reload PATH variable! Project-Id-Version: BASH3 Boilerplate by krisztianmukli
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2018-06-25 13:45+0200
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
Last-Translator: Mukli Krisztián <krisztianmukli@mukli.hu>
Language-Team: Mukli Krisztián <krisztianmukli@mukli.hu>
X-Generator: Poedit 2.0.6
X-Poedit-SourceCharset: UTF-8
 Használható argumentumok:

  -c --check-dependencies  Ellenőrzi a megadott szkript függőségeit
  -d --debug               Hibakeresési mód engedélyezése
  -f --force               Utasítások erőltetése (pl. fájlok felülírásánál)
  -h --help                Súgó
  -i --ini [inifile]       Telepítéshez használt .ini-fájl. Ha nincs megadva a telepítő a [sourcedir]/install.ini -t használja.
  -n --no-color            Színes kimenet kikapcsolása
  -s --source [sourcedir]  Szkript forráskönyvtára. Alapértelmezett="$(pwd)"
  -t --target [targetdir]  Célkönyvtár. Optional, if not specified, installer use /usr/local/bin or ~/.local/bin
  -v                       Részletes mód engedélyezése, kiíratja a szkriptet futás közben
  -V --version             Verzió és licencinformációk megjelenítése Nem folytatható LOG_LEVEL nélkül. Takarítás. Kész Alapértelmezett Megadott célkönyvtár: ${defined_targetdir} Hiba a ${__si_file} fájl ${function} funkciójában a ${line}. sorban Csomagtelepítés kész A következő csomagok hiányoznak: ${missingpkgs}, szeretné telepíteni őket? A következő csomagok telepítéséhez macOS alatt a HomeBrew vagy a Macports szükséges: ${missingpkgs} ${__si_base} súgó Ini-fájl: ${inifile} Szkript telepítése manuálisan:
  *Másolja le a szkriptet és 'lib' mappa tartalmát egy a PATH környezeti változóban megtalálható mappába.
*
  * Másolja le a 'locale' mappa tartalmát a lokalizációs fájlok helyére.
  *Telepítse a függőségeket. A következő csomagok telepítéséhez a rendszerhéjból cygwin alatt, szükség van az apt-cyg parancsra, vagy használhatjuk a Cygwin setup.exe-jét: ${missingpkgs} A(z) ${lib} telepítése a(z) ${libtargetdir} mappába sikeres A(z) ${script} telepítése a(z) ${targetdir} mappába sikeres Fájlok sikeresen telepítve a(z) ${targetdir} mappába A következő függőségek telepítése sikeres: ${missingpkgs} Telepítés sikertelen: ${libsourcedir} nem létezik! Telepítés sikertelen: ${libtargetdir} nem írható Telepítés sikertelen: ${localetargetdir}  nem írható Telepítés sikertelen: ${sourcedir} nem létezik! Telepítés sikertelen: ${targetdir} nem írható Telepítés sikertelen: Nem lehet létrehozni a(z) ${libtargetdir} mappát Telepítés sikertelen: nem lehet létrehozni a(z) ${localetargetdir} mappát Telepítés sikertelen: nem lehet létrehozni a(z) ${targetdir} mappát Telepítés sikertelen: hiba történt a fájlok másolása közben Telepítés sikertelen: hiba történt a függőségek telepítése során Telepítés sikertelen: nem támogatott fájlnév ($lib) Telepítés sikertelen: nem támogatott fájlnév (${payload}) Telepítés sikertelen: nem támogatott fájlnév (${script}) Szkript érvénytelen használata: ${__si_tmp_params} MIT licensz alatt kiadva Hiányzó függőségek: ${missingpkgs} Nincs érvényes csomag A(z) -${__si_tmp_opt_short}${__si_tmp_opt_long:-} kapcsolónak argumentum megadása szükséges Kötelező Futtatási jogok beállítása sikertelen a ${targetdir}/${script} fájlra! Lehetséges, hogy magasabb jogosultságok szükségesek! Forrásmappa: ${sourcedir} Önálló szkript telepítő Csomagtelepítés indítása Célkönyvtár a lokalizációs fájloknak: ${localedir} Célkönyvtár, ahova a szkript telepítésre kerül: ${targetdir} Célkönyvtár, ami hozzáadásra kerül a ~/.profile fájlhoz: ${targetdirtext} Telepíti a megadott könyvtárból a bash-szkripteket, az install.ini fájl használatával.
 A BASH3 Boilerplate by krisztianmukli projekt része. Ismeretlen hiba csomagtelepítés közben! Ismeretlen vagy nem támogatott operációs rendszer, nem lehet telepíteni a következő csomagokat: ${missingpkgs} Nem támogatott operációs rendszer. A telepítés nem lehetséges. Felhasználó mappája: ${__si_user_home} Magasabb jogosultságokra van szükség a csomagok telepítéséhez! A ~/.profile fájl módosításra került, jelentkezzen be újra, vagy futassa a 'source ~/.profile' utasítást a PATH környezeti változó értékének frissítéséhez! 