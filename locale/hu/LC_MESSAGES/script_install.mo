��          �            h  �  i  #        3     E  3   M     �  {   �          )  H   H     �     �  �   �     `  B  ~    �  %   �
     �
       <   "     _  �   k  '        C  _   [  
   �     �  �   �  %   �               
                                                       	          -c --check-dependencies  Check dependencies of specified script
  -d --debug               Enables debug mode
  -f --force               Forcing commands (e.g. overwrite existing files)
  -h --help                This page
  -i --ini [inifile]       Ini-file using the installation. Default=\"install.ini\"
  -n --no-color            Disable color output
  -s --source [sourcedir]  Source dir of script. Default=.
  -t --target [targetdir]  Target directory. Optional, if not specified, installer use /usr/local/bin or ~/.local/bin
  -v                       Enable verbose mode, print script as it is executed
  -V --version             Display version and license information Cannot continue without LOG_LEVEL.  Cleaning up. Done Default Error in ${__si_file} in function ${1} on line ${2} Help using ${0} Install script manually: 
* Copy the script and the lib folder to your PATH.
* Copy to locale folder to your locale folder. Invalid use of script: ${*} Licensed under the MIT license Option -${__si_tmp_opt_short}${__si_tmp_opt_long:-} requires an argument Required Standalone script installer This command can install bash-script and it's dependencies from a specified
 folder, using install.ini file. 
 It is part of BASH3 Boilerplate by krisztianmukli project. Unsupported operating system. Project-Id-Version: BASH3 Boilerplate by krisztianmukli
PO-Revision-Date: 
Last-Translator: Mukli Krisztián <krisztianmukli@mukli.hu>
Language-Team: Mukli Krisztián <krisztianmukli@mukli.hu>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: Poedit 2.0.6
 -c --check-dependencies  Megadott szkript függőségeinek ellenőrzése
  -d --debug               Hibakeresési mód
  -f --force               Utasítások erőltetése (pl. létező fájlok felülírása)
  -h --help                Súgó
  -i --ini [inifile]       Telepítéshez használt ini-fájl. Alapértelmezett=\"install.ini\"
  -n --no-color            Színes kimenet kikapcsolása
  -s --source [sourcedir]  Szkript forráskönyvtára. Alapértelmezett=.
  -t --target [targetdir]  Célkönyvtár. Opcionális, ha nicns megadva, a telepítő a /usr/local/bin vagy ~/.local/bin könyvtárakat használja
  -v                       Részletes mód engedélyezése, kiíratja a szkriptet futás közben
  -V --version              Verzió és licencinformációk megjelenítése Nem folytatható LOG_LEVEL nélkül.  Takarítás. Kész Alapértelmezett Hiba a ${__si_file} fájl ${1} funkciójában a ${2}. sorban ${0} súgó Szkript telepítése manuálisan:
* Másolja a szkriptet és a 'lib' könytárat a PATH egy könyvtárába.
* Másolja a 'locale' könyvtárat a rendszer 'locale' mappájába. Szkript érvénytelen használata: ${*} MIT licenc alatt kiadva A(z) -${__si_tmp_opt_short}${__si_tmp_opt_long:-} kapcsolónak argumentum megadása szükséges Kötelező Önálló szkript telepítő Ez az utasítás a megadott könyvtárból telepíti a bash-szkripteket és azok függőségeit
az ini-fájl használatával. 
A BASH3 Boilerplate by krisztianmukli projekt része. Nem támogatott operációs rendszer. 