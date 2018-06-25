��    3      �  G   L      h  �  i  "   H     k     }  (   �  =   �  !   �  O     ]   ^     �     �  �   �     �	  9   	
  9   C
  0   }
  D   �
  9   �
  7   -  :   e  6   �  4   �  9     <   F  6   �  B   �  L   �  6   J  <   �  ;   �  )   �     $  $   C     h  H   z     �  l   �     9     R     n  /   �  :   �  E   �  �   =  )   �  Z     ;   l  "   �  3   �  f   �  �  f  �     "   �     "     4  (   <  =   e  !   �  O   �  ]        s     �  �   �     @  9   �  9   �  0   4  D   e  9   �  7   �  :     6   W  4   �  9   �  <   �  6   :  B   q  L   �  6     <   8  ;   u  )   �     �  $   �       H   1     z  l   �     �     	     %  /   C  :   s  E   �  �   �  )   �   Z   �   ;   #!  "   _!  3   �!  f   �!     +                  	           #          .         )                           
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
PO-Revision-Date: 2018-06-25 13:03+0200
Last-Translator: Mukli Krisztián <krisztianmukli@mukli.hu>
Language-Team: Krisztian Mukli <krisztianmukli@mukli.hu>
Language: en_US
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: Poedit 2.0.6
X-Poedit-SourceCharset: UTF-8
Plural-Forms: nplurals=2; plural=(n != 1);
 Available arguments:

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
 It is part of BASH3 Boilerplate by krisztianmukli project. Unknown error during installing packages! Unknown or unsupported operating system, cannot install following packages: ${missingpkgs} Unsupported operating system. Installation is not possible. User's home dir: ${__si_user_home} You need higher privileges for installing packages! ~/.profile was updated, please login again or run 'source ~/.profile' command to reload PATH variable! 