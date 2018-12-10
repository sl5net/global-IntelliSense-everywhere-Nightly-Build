﻿# global-IntelliSense-everywhere 
 
English: Automates context-sensitive writing and action.
Is an unobtrusive IntelliSense for all programs, all websites, all apps, all windows, just everything that runs in Windows.

German: Automatisiert kontextsensitives Schreiben und Handeln.
Ist eine unaufdringliche IntelliSense für alle Programmen, alle Webseiten, alle Apps, alle Fenster, für einfach alles was in Windows läuft.

- - -

Its Sponsored!
This project is sponsored by JetBrains.  JetBrains is a software development company whose mission is to make the strongest, most effective developer tools on earth. Their tools speed up production, freeing developers to grow, discover and create. 

[![JetBrains Logo](https://www.isic.nl/media/1391607/jetbrains.jpg?width=448&height=277&mode=crop&scale=both) 
 
This international company has a user base of 4+ million users across 140 countries.  The company has won over 300+ awards.  Their customer base includes, The New York Times, CitiBank, Twitter, Pinterest, NASA, Salesforce and Samsung.

- - -

[![global IntelliSense everywhere examples windows autohotkey](https://img.youtube.com/vi/elLsl8lj0K8/0.jpg)](https://www.youtube.com/watch?v=elLsl8lj0K8)
  
- please install AHK first (pls use version: v1.1.28.00 - February 11, 2018 or later).
from:
[heise.de/download/product/autohotkey-20763](https://www.heise.de/download/product/autohotkey-20763)
or: https://autohotkey.com/
[autohotkey.com/](https://autohotkey.com)
- then download:
 [github.com...master](https://codeload.github.com/sl5net/global-IntelliSense-everywhere/zip/master)
  or 
  [github.com...zipball/master/](https://github.com/sl5net/global-IntelliSense-everywhere/zipball/master/)
  or 
  [github.com...zipball Nightly-Build](https://github.com/sl5net/global-IntelliSense-everywhere-Nightly-Build/zipball/master/)
- Start start.ahk

(Suggestions for improvement, criticism, questions are expressly desired. Many Thanks.)


Please configure ActionList by any texteditor you like.
and you may wanna edit the ActionListNameFilter.inc.ahk inside your new folder ( ActionLists/YourNewClass/ActionListNameFilter.inc.ahk ).

There is also a global 
/ActionLists/ActionListNameFilter.inc.ahk
you may wanna edit ( ActionLists/YourNewClass/ActionListNameFilter.inc.ahk ).

The ActionListNameFilter.inc.ahk files are meant to be redirected to ActionLists (superglobal, global or local, ...) if you do not have the normal configuration.

Please handle the globals ActionListNameFilter.inc.ahk carefully, as it could be otherwise that the whole script does not work anymore.

The first steps will probably be that you only edit the ActionLists / YourNewClass / yourNewTitle.ahk. The simplest change is just to add one line of text.


please report Issues here:
https://g-intellisense.myjetbrains.com/youtrack/issues?q=State:%20%7BIn%20Progress%7D,%20Incomplete,%20Submitted,%20%7BTo%20be%20discussed%7D%20sort%20by:%20Priority%20asc%20 (prefered place)
or https://github.com/sl5net/global-IntelliSense-everywhere/issues
or https://autohotkey.com/boards/viewtopic.php?f=6&t=45684 
or essential-freebies.de/board/viewtopic.php?f=33&t=18557 




its using (many thanks for it):
- regex (very often)
- windows OS
- autohotkey
- TypingAid.ahk
- ADO.ahk
- ArchLogger.ahk
- Base.ahk
- clean.bat
- Collection, ahk
- DataBaseAbstract. ahk
- DataBaseADO.ahk
- DataBaseFactory.ahk
- DataBaseMySQL.ahk
- DataBaseSQLLite .ahk
- DBA.ahk
- MemoryBufFer.ahk
- mySQL.ahk
- RecordSetADO.ahk
- RecordSetMySQL, ahk
- RecordSetSqlLite .ahk
- sizeof.ahk
- SQLite_L.ahk

Credits:
- Maniac
- Jordi S
- HugoV
- kakarukeys
- Asaptrad
- j4hangir
- Theclaw
- rommmcek
- jamesw77bp
- jeeswg
- fridemarDrPache
- and many more
