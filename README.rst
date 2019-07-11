Erstellen einer Consul Entwicklungsumgebung - PUBLIC
====================================================

|license| |maintenance|

|Build Status| |Codecov Status| |Better Code| |code climate| |snyk security|

.. |license| image:: https://img.shields.io/github/license/webcomics/pywine.svg
   :target: http://en.wikipedia.org/wiki/MIT_License
.. |maintenance| image:: https://img.shields.io/maintenance/yes/2019.svg
.. |Build Status| image:: https://travis-ci.org/bitranox/setup_consul_development.svg?branch=master
   :target: https://travis-ci.org/bitranox/setup_consul_development
.. |Codecov Status| image:: https://codecov.io/gh/bitranox/setup_consul_development/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/bitranox/setup_consul_development
.. |Better Code| image:: https://bettercodehub.com/edge/badge/bitranox/setup_consul_development?branch=master
   :target: https://bettercodehub.com/results/bitranox/setup_consul_development
.. |snyk security| image:: https://snyk.io/test/github/bitranox/setup_consul_development/badge.svg
   :target: https://snyk.io/test/github/bitranox/setup_consul_development
.. |code climate| image:: https://api.codeclimate.com/v1/badges/ff3f414903627e5cfc35/maintainability
   :target: https://codeclimate.com/github/bitranox/setup_consul_development/maintainability
   :alt: Maintainability

Die hier vorgestellten Skripte dienen zur Einrichtung einer Standardisierten Entwicklungsumgebung für Consul unter Ruby.
Über diese Skripte wird entweder auf einem Linux Host, oder auf einer virtuellen Maschine (VM-Ware) ein LXC Container (dies ist eine weitere virtuelle Maschine) erstellt.
Es wird alle Software installiert um Consul auszuführen (Entwicklungs & Testumgebung - keine Produktionsumgebung, diese hat andere, höhere Voraussetzungen !)

Getestet unter:
 - automatische Erstellung der LXC Container : Ubuntu 19.04 (disco) jeweils in der minimalen installation Deutsch, entweder direkt auf einem Rechner installiert (bevorzugt) oder auf einer virtuellen Maschine.
 - Ruby / Consul Installation :  Ubuntu 18.04 (bionic), Ubuntu 19.04 (disco) jeweils Server und Desktop

----

- `Voraussetzungen`_
- `Installation`_
- `Grundlegende Verwendung`_
- `Danksagungen`_
- `Beitragen`_
- `Probleme melden <https://github.com/bitranox/setup_consul_development/blob/master/ISSUE_TEMPLATE_de.md>`_
- `Pull Request <https://github.com/bitranox/setup_consul_development/blob/master/PULL_REQUEST_TEMPLATE_de.md>`_
- `Verhaltenskodex für Mitwirkende <https://github.com/bitranox/setup_consul_development/blob/master/CODE_OF_CONDUCT_de.md>`_
- `Lizenz`_

----

Voraussetzungen
---------------

- Hardware
    Es reicht ein handelsüblicher PC, wir empfehlen mindestens 4 Kerne, 16 GB Ram, ca. 100GB fei auf der Festplatte, möglichst eine SSD

- Netzwerk
    eine funktionierende Internetverbindung zum Herunterladen der Skripte und Software

- Software
    Es wird ausschließlich freie Software verwendet. Wenn Sie den Entwicklungsrechner in einer virtuellen Maschine laufen lassen,
    so benötigen Sie einen entsprechenden Hypervisor - z.B. VM-Ware Workstation (Pro)
- Kenntnisse
    Grundlegende Kenntnisse - bei Fragen wird die Dokumentation entsprechend erweitert.
    Zur Entwicklung in Consul selbst sind Ruby Kenntnisse notwendig.
    Wenn nur Templates / Texte etc. angepasst werden sollen, so sind grundlegende Kenntnisse in HTML / CSS / Aufbau von YAML-Konfigurationsfiles notwendig.
    Diese Fragen werden hier nicht behandelt - in diesem Repository geht es lediglich um die Einrichtung einer Entwicklungs- und Testumgebung.

Installation
------------

- `Installationsvarianten`_
- `Host System`_
- `mit virtueller Maschine`_
- `ohne virtueller Maschine`_
- `Installation der Skripte`_
- `Essentielle, automatisch Installierte Programme`_
- Installation des Host Systemes
    - `install_or_update`_ - Einmalig vor Verwendung der nachfolgenden Skripte ausführen, um die neuesten Versionen zu erhalten !
    -  BIS HIER GETESTET NACHFOLGENDES FUNKTIONIERT NOCH NICHT
    - `001_000_install_languagepack`_
    - `002_000_install_ubuntu_mate_desktop`_
    - `003_000_remove_unnecessary`_
    - `004_000_install_tools`_
- Installation der LXC Container - alternativ, jedoch EMPFOHLEN, es zahlt sich aus !
    - `005_000_install_lxd_container_system`_
    - `006_000_configure_lxd_container_system`_
    - `007_000_create_clean_lxc_container`_
    - `Grundlegende Befehle für LXC Container`_
- sonstige Einrichtung
    - `Chrome Remote Desktop einrichten`_
- Installation von Consul
    - `Installation von Consul - Vorbereitung`_
    - `008_000_install_postgresql`_
    - `009_000_install_ruby`_
    - `010_000_configure_consul_user`_

----

- die Erstellung der LXC Container samt Namensauflösung läuft derzeit nur unter Ubuntu Desktop 19.04
- der Datenbankserver postgresql lauft unter Ubuntu 18.04/19.04 Desktop oder Server
- Ruby und Consul laufen unter Ubuntu 18.04/19.04 Desktop oder Server
- die Ruby Entwicklungsumgebung läuft unter Ubuntu Desktop 18.04/19.04
- für die Entwicklungsmaschine werden alle diese Programme am Besten auf einem Ubuntu 19.04 Desktop installiert, manche Skripte (für Server) sind jedoch bereits für die Installation auf einem Serversystem vorbereitet.


Folgende Installationsvarianten sind möglich:

----

Installationsvarianten
----------------------

Es gibt verschiedene Varianten um eine Produktionsumgebung zu erreichen :

wir schlagen vor die Entwicklungsumgebung auf dem Hostsystem Ubuntu 19.04 in LXC Containern laufen zu lassen.
Diese Container können sehr leicht für diverse Tests geklont werden, auch Cluster mit mehreren parallel laufenden LXC Containern sind leicht möglich.

Das Hostsystem kann wiederum in einer Virtuellen Maschine (VMWare) laufen.

Die Ruby Entwicklungsumgebung kann auch direkt auf dem Hostsystem installiert werden. Wie auch immer - wir empfehlen die Verwendung von LXC Containern.


Host System
-----------

Das Host System besteht aus einem Linux Desktop Betriebssystem.
Wenn Sie die LXC Container automatisch mit unseren Skripten installieren möchten (empfohlen), so wird Version 19.04 (disco) benötigt - 18.04 funktioniert NICHT.
Es wird von einer frischen, minimalen Installation des Hostsystemes ausgegangen.
Das Host System kann natürlich auch auf einer Virtuellen Maschine (VM-Ware) laufen.


mit virtueller Maschine
-----------------------
Exemplarisch verwenden wir eine VM-Ware Workstation Pro - es wird eine neue virtuelle Maschine mit folgenden Settings erstellt:

Erzeugen Sie eine neue VM:

- Hostname (Vorschlag): consul-development-host
- Benutzername (Vorschlag): consul
- Passwort (Vorschlag): consul
- 4 (besser 8) Cores, je nachdem wieviele Cores Ihr Rechner zue Verfügung hat
- 8192MB Speicher (4096 geht sicherlich auch)
- 500GB Festplatte (in einem File, wird ohnehin dynamisch je nach Platzbedarf verwendet)
- Bridged Networking

auf diese virtuelle Maschine installieren Sie nun ein Ubuntu Desktop 19.04 - nur das notwendigste !

Installieren Sie jedenfalls die open-vm-tools:

.. code-block:: bash

    # Installiere Open VM Tools
    sudo apt-get install open-vm-tools -y


ohne virtueller Maschine
------------------------
Es werden nur sehr wenige globale Änderungen am Hostsystem durchgeführt - d.h. wenn Sie bereits einen Linux Desktop verwenden,
so können Sie unsere Installationsskripte benutzen. Veränderte Konfigurationsdateien werden mit der Erweiterung .original gesichert.
Nebeneffekte werden nach Möglichkeit vermieden bzw. dokumentiert, können wir aber nicht ausschließen. Verwenden Sie
(insbesondere wenn keine guten Linux Kenntnisse vorhanden sind) daher unsere Skripte NICHT auf Produktionsmaschinen oder Maschinen
auf deren Funktion Sie angewiesen sind. Eine Datensicherung vor Verwendung unserer Skripte ist zu empfehlen.

Installation der Skripte
------------------------

Die Installation ist in eine Anzahl von Skripten aufgeteilt, um insbesondere für bereits bestehende Linux Hosts,
bzw für bereits aufgesetzte Linux Rechner eine flexiblere Installation zu ermöglichen.

Für "frisch aufgesetzte" Linux Rechner bzw. virtuelle Maschinen können die vorliegenden Skripte einfach der Reihe nach aufgerufen werden.

Wir gehen nun davon aus, das Betriebssystem läuft. Wechseln Sie auf die Konsole (Terminal).

.. code-block:: bash

    # maschine updaten
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get autoclean
    sudo apt-get autoremove
    # install git
    sudo apt-get install git -y
    # Herunterladen der Skripte
    sudo git clone https://github.com/bitranox/setup_consul_development.git /usr/local/setup_consul_development
    # Skripte ausführbar machen
    sudo chmod -R +x /usr/local/setup_consul_development/*.sh
    cd /usr/local/setup_consul_development
    sudo ./install*


die Skripte befinden sich nun im Verzeichnis /usr/local/setup_consul_development
Dies können Sie händisch in der Konsole machen, oder über einen Dateimanager (Nautilus, Caja, etc...) aufrufen.

Die Skripte sind nummeriert und lassen sich so leicht auch manuell aufrufen :

.. code-block:: bash

    # wechsel in das Skript Verzeichnis
    cd /usr/local/setup_consul_development

    # Aufruf des Skriptes install_or_update.sh
    # so können Sie sehr schnell die Skripte ohne große Tipparbeit in der Konsole ausführen
    # alternativ können Sie natürlich sie Skripte über den Dateimanager starten
    # Die Skripte werden automatisch beim Aufruf auf die neueste Version upgedated.
    # wenn Sie z.Bsp. das Skript /usr/local/setup_consul_development/001_000_install_languagepack.sh
    # aufrufen möchten so gehen Sie wie folgt vor :
    cd /usr/local/setup_consul_development
    ./001*      # das spart Ihnen jede Menge Tipparbeit



Essentielle, automatisch Installierte Programme
-----------------------------------------------

folgende Programme werden bei Verwendung dieser Skripte automatisch, ohne Rückfrage installiert:

- net-tools (grundlegende Netzwerk Tools)
- git

install_or_update
-----------------

Dieses Skript führt ein Update der eigenen Installationsskripte durch.
Sobald auf Github eine neue Version vorliegt, werden bei Aufruf eines der nachfolgenden Skripte automatisch ein Update ausgeführt.
Achtung, etwaige eigene Änderungen in diesen Skripten werden überschrieben !

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./install_or_update.sh

001_000_install_languagepack
---------------------------

Installation des Deutschen Sprachpaketes für Linux. Auch wenn Sie es vielleicht bereits haben - es schadet nicht.

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./001*

002_000_install_ubuntu_mate_desktop
----------------------------------
Für Ubuntu-Desktop Versionen OPTIONAL, für Ubuntu Server zwingend notwendig !

Installation des Ubuntu-Mate-Desktops - diese Desktopumgebung ist mehr Windows-ähnlich,
viele Leute (so auch ich) kommen mit dem neuen Ubuntu-Gnome Desktop nicht so gut zurecht.

Die Netzwerksettings unter /etc/netplan/ werden automatisch auf Netzwerkmanager geändert!

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./002*

003_000_remove_unnecessary
-------------------------
Für die Entwicklung unnötige Programme deinstallieren. Darunter fallen viele Tools wie VIM, Brasero, aber auch
Thunderbird Mailprogramm, Dateimanager Nautils (Mate verwendet Caja), oder Libre Office.
Führen Sie dieses Script nur dann aus, wenn Sie SICHER sind das Sie keines dieser Programme benötigen !

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./003*

004_000_install_tools
--------------------
Installation von notwendigen Tools wie snap, geany, mc, meld, build-essential, synaptics, x2goclient

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./004*

005_000_install_lxd_container_system
-----------------------------------
Installation des LCD Container Systemes (nur wenn Sie LXC Container verwenden möchten)

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./005*

006_000_configure_lxd_container_system
-------------------------------------
Konfiguration des LXC Systemes (nur wenn Sie LXC Container verwenden möchten)
 - anlegen eines Shared Directories zum Dateiaustausch unter $HOME/lxc-shared
 - Disk Device zu Shared Directory zu Profile "default" hinzufügen
 - subuid, subgid setzen
 - raw idmap im profile setzen (für Zugriffsberechtigung auf Shared Directory)
 - lcx network bridge DNS Zone .lxd einrichten (die container sind dann im DNS unter <containername>.lxd eingetragen
 - systemd-resolved konfigurieren, DNS Zone .lxd wird auf der lxdbr0 Bridge abgefragt

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./006*

007_000_create_clean_lxc_container
---------------------------------
Erzeugen des ersten LXC Containers (nur wenn Sie LXC Container verwenden möchten)
Erzeuge einen sauberen LXC Container lxc-clean, mit Benutzer consul, passwort consul.
Dieser Container ist dann über den X2GO Client über die Adresse lxc-clean.lxd erreichbar.
(auch über SSH, etc)

.. code-block:: bash

    cd /usr/local/setup_consul_development
    ./007*

Der LXC Container läuft nun und ist über SSH erreichbar.

Starten Sie nun den X2GO Client an Hostsystem (aud fer VM soferne verwendet) und erzeugen Sie eine neue Sitzung mit folgenden Einstellungen :

 - Name : lxc-clean.lxd
 - Host: lxc-clean.lxd
 - Login: consul
 - Sitzungsart: MATE
 - Reiter "Verbindung" : LAN
 - Reiter "Ein-/Ausgabe" : Auflösung nach Geschmack einstellen
 - Reiter "Medien" : Audio nach Geschmack ausschalten

Sie können sich nun mit dem laufenden LXC Container verbinden.

Im allgemeinen können Sie nun bereits auf dem LXC Container arbeiten - wir empfehlen jedoch zusätzlich zu X2GO Chrome Remote Desktop zu installieren.
Dies ist viel performanter. Installieren Sie Google Chrome sowie Chrome Remote Desktop auf dem LXC Container und schalten Sie die Freigabe ein.
Dann können Sie Ihre Virtuelle Maschine (soferne Sie diese verwenden) im Hintergrund laufen, und von Ihrem Grundsystem über Chrome Remote Desktop auf die laufenden Container zugreifen.

Sollten Sie den Container lxc-clean neu erstellen wollen, so rufen Sie das Skript 007_create_clean_lxc_container.sh einfach nochmals auf (es gibt dazu aber eine bessere Variante, dazu später).

Auf dem Container sind die Installationsskripte bereits installiert - wenn Sie möchten können Sie die überflüssigen Programme am Container wie folgt entfernen

.. code-block:: bash

    # am LCX Container ausführen !
    cd /usr/local/setup_consul_development
    ./install_or_update.sh       # skripte updaten
    ./003*                       # überflüssige Programme entfernen

    # nun am Host ausführen
    lxc stop lxc-clean                                      # container stoppen
    lxc publish lxc-clean --alias lcx-clean-fresh-minimal   # neues Image erstellen das alte Image ann wie unten Beschrieben gelöscht werden


Grundlegende Befehle für LXC Container
--------------------------------------

Die LXC Container sind sehr performante Virtuelle Maschinen, welche auf Ihrem Hostsystem laufen.

- Sie können mehrere LXC Container parallel laufen lassen (und gleichzeitig Remote auf diese Container zugreifen)
- Sie können LXC Container in Images exportieren
- Sie können aus diesen Images neue Container erstellen
- Sie können über Profile diesen Container Eigenschaften zuordnen
- es gibt noch viele weitere Möglichkeiten, wie z.Bsp. Snaphots usw - konsultieren Sie dazu die LXC Dokumentation.

wir haben folgendes für Sie eingerichtet :

- einen container "lxc-clean"
- ein image "lxc-clean-fresh" (daraus können Sie jederzeit einen neuen Container mit dem Inhalt von "lxc-clean" erzeugen)
- das Profil "default" wurde erweitert, um auf das shared Verzeichnis "/media/lxc-shared" zuzugreifen.
  So können die Container auf das Host Verzeichnis "/media/lxc-shared" zugreifen - damit können Sie einfach Dateien mit dem Host oder zwischen lxc-containern austauschen.

.. code-block:: bash

    # container auflisten
    lxc list
    +-----------+---------+----------------------+-----------------------------------------------+------------+-----------+
    |   NAME    |  STATE  |         IPV4         |                     IPV6                      |    TYPE    | SNAPSHOTS |
    +-----------+---------+----------------------+-----------------------------------------------+------------+-----------+
    | lxc-clean | RUNNING | 10.147.11.150 (eth0) | fd42:10a7:7208:bd35:216:3eff:fec0:27ba (eth0) | PERSISTENT |           |
    +-----------+---------+----------------------+-----------------------------------------------+------------+-----------+

    # container stoppen
    lxc stop lxc-clean
    lxc list
    +-----------+---------+------+------+------------+-----------+
    |   NAME    |  STATE  | IPV4 | IPV6 |    TYPE    | SNAPSHOTS |
    +-----------+---------+------+------+------------+-----------+
    | lxc-clean | STOPPED |      |      | PERSISTENT |           |
    +-----------+---------+------+------+------------+-----------+

    # images auflisten
    lxc image list
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+
    |      ALIAS      | FINGERPRINT  | PUBLIC |               DESCRIPTION               |  ARCH  |   SIZE    |         UPLOAD DATE          |
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+
    | lxc-clean-fresh | 9975e04fd183 | no     |                                         | x86_64 | 2316.91MB | Jun 29, 2019 at 6:43pm (UTC) |
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+
    |                 | ee3259ee512f | no     | ubuntu 19.04 amd64 (release) (20190627) | x86_64 | 319.74MB  | Jun 29, 2019 at 1:29pm (UTC) |
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+

    # images löschen
    # wenn Sie Platznot haben, können sie alte Images löschen - Sie können dazu entweder den ALIAS oder die ersten paar Ziffern des FINGERPRINT angeben :
    # folgender Befehl würde das Image welches zur ersten Erstellung des Containers lxc-clean gedient hat löschen (das brauchen wir nicht mehr)
    lxc image delete ee3  # Ihr Fingerprint wird eine andere Nummer haben - dies ist eine Prüfsumme
    lxc image delete
    lxc image list
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+
    |      ALIAS      | FINGERPRINT  | PUBLIC |               DESCRIPTION               |  ARCH  |   SIZE    |         UPLOAD DATE          |
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+
    | lxc-clean-fresh | 9975e04fd183 | no     |                                         | x86_64 | 2316.91MB | Jun 29, 2019 at 6:43pm (UTC) |
    +-----------------+--------------+--------+-----------------------------------------+--------+-----------+------------------------------+


    # profile auflisten
    lxc profile list
    +----------------+---------+
    |      NAME      | USED BY |
    +----------------+---------+
    | default        | 1       |
    +----------------+---------+

    # neuen Container aus Image erzeugen
    # es wird Zeit aus dem Image lxc-clean-fresh einen lxc container zum testen zu erzeugen
    lxc init lxc-clean-fresh lxc-test                     # erzeuge aus dem Image lxc-clean-fresh einen neuen Container lxc-test
    lxc start lxc-test                                    # starten des neuen Containers lxc-test
    # auf diesen Container können Sie wieder mit X2go über Adresse lxc-test.lxd zugreifen

    # neues Image erzeugen
    # wenn Sie nun den Container lxc-test so hergerichtet haben wie Sie möchten, (Hintergrund, Chrome Remote Desktop, etc ... )
    # so können Sie diesen Container wieder als Image abspeichern und daraus neue Container erzeugen
    lxc stop lxc-test                                   # container stoppen
    lxc publish lxc-test --alias lxc-mydevelop-clean    # container unter image "lxc-mydevelop-clean" abspeichern

    # jetzt können Sie beliebig viele neue Testcontainer schnell erzeugen - einfach
    lxc init lxc-mydevelop-clean lxc-test2                # container lxc-test2 aus image lxc-mydevelop-clean erzeugen.

    # so starten Sie nun alle drei container gleichzeitig - WHOW.
    # Images können nicht gestartet werden - das sind sozusagen Backups von Containern.
    # auf alle Container können Sie wiederum mit X2Go unter der Adresse <containername>.lxd zugreifen ! Gleichzeitig !
    # Wir empfehlen jedoch chrome-remote-desktop zu installieren, das ist performanter.
    lxc start lxc-test
    lxc start lxc-test2
    lxc start lxc-clean

    # console eines lxc-containers aufrufen
    # wenn einmal das Netzwerk des Containers nicht funktioniert,
    # oder Sie einen neuen Container ohne SSH und grafischem Desktop installiert haben,
    # so können Sie von Host Rechner wie folgt auf die Console des LXC Containers zugreifen :
    lxc exec <containername> /bin/bash

    # stoppen des Host Systemes
    # wenn Sie das Host System bei laufenden LXC Containern herunterfahren, so werden diese Container automatisch
    # beim Neustart des Host Systemes wieder gestartet.
    # wir empfehlen Ihnen sich verschieden Hintergründe mit dem Rechnernamen im Bild für die Container zu erstellen -
    # sonst kommt man schnell mal mit den vielen Maschinen durcheinander.
    # nehmen Sie dazu einfach einen vorhandenen Hintergrund und fügen Sie mit einem Grafikprogramm den Rechnernamen
    # samt anderen nützlichen Informationen ein.


Chrome Remote Desktop einrichten
--------------------------------

Chrome Remote Desktop sollten Sie sowohl am (virtualisierten) Hostsystem, als auch auf den LXC Containern einrichten.
Damit können Sie sehr performant über Ihr Basissystem, oder über Weltweit jeden Rechner auf diese vielen Container zugreifen.
Sie können auch temporär einzelne Container für andere Personen, z.B. für Remote Hilfe freigeben - Sehr praktisch und empfohlen !

Wir haben Google Chrome und Chrome Remote Desktop bereits vorinstalliert.

Um Chrome Remote Desktop einzurichten, öffnen Sie den Chrome Browser und geben in der Adresszeile https://remotedesktop.google.com/access ein.
Melden Sie sich mit Ihrem Google Account an und wählen Sie auf der nun angezeigten Webseite "Remotezugriff einrichten" / Hinzufügen / Add Extension aus.
Nun können Sie einen Namen und einen PIN (zur Erstmaligen Verbindung) für Ihre Maschine eingeben. Da der Zugriff ohnehin an Ihr Google Account geknüpft ist,
können Sie überall den selben Pin verwenden.

Wiederholen Sie den Vorgang für all Ihre LXC Container und das Hostsystem auf der VMWare.

Nun können Sie den X2Go Client schließen (der Container läuft ja im Hintergrund weiter),
und Ihre VMWare minimieren, bzw. können Sie die VMWare auch mit der Option "virtuelle Maschine im Hintergrund ausführen" beenden.

Sie können nun auf die Maschinen mit dem Google Browser, der Chrome Remote Software, Tablet, Handy etc. leicht und sehr performant
 - auch über die Grenzen Ihre Firewall hinweg - zugreifen. Auch wenn Sie keine statische IP Adresse haben.

Als maximale Auflösung haben wir 5120x1600 voreingestellt, dieses Setting finden Sie unter /etc/environment


---

Installation von Consul - Vorbereitung
--------------------------------------

wir gehen nun davon aus, das Sie zu dem laufenden LXC Container oder dem Desktop Host System verbunden sind,
auf dem Consul installiert werden soll.

Einige Skripte können auch auf Servern ohne grafischer Benutzeroberfläche verwendet werden, diese sind besonders gekennzeichnet.

Führen Sie nun auf dieser Maschine die unter `Installation der Skripte`_ beschriebenen Schritte aus, um die Skripte
auch auf dem Container zu installieren.

008_000_install_postgresql
-------------------------

Installation des Datenbankservers. Die Installation besteht aus zwei Unterskripten, welche Sie auch einzeln aufrufen können.

- 008_000_install_postgresql
    - ruft beide untenstehenden Skripte auf
    - getestet auf Ubuntu 18.04/19.04 Desktop
- 008_001_install_postgresql_server.sh
    - Installiert den Postgres SQL Server
    - getestet auf Ubuntu 18.04/19.04 Desktop und Server
- 008_002_install_postgresql_pgadmin4
    - Installiert das Administrationstool für Postgres - dies macht nur Sinn auf Maschinen mit grafischem Desktop
    - getestet auf Ubuntu 18.04/19.04 Desktop

.. code-block:: bash

    cd /usr/local/setup_consul_development
    # für Desktop Maschinen:
    ./008*
    # alternativ für Server:
    ./008-001*


009_000_install_ruby
-------------------

Installation von Ruby, nodejs und npm
getestet auf Ubuntu 18.04/19.04 Desktop und Server

.. code-block:: bash

    cd /usr/local/setup_consul_development
    # für Desktop oder Server Maschinen:
    ./009*


010_000_configure_consul_user
----------------------------

Gems sind die Bibliotheken von Ruby - es ist darauf zu Achten das gems NICHT ALS ROOT installiert werden.

Wir wollen mehrere Versionen von Consul (Originalversion, Entwicklungsversion, Testversion, etc ...) gleichzeitig auf dieser Maschine laufen lassen.
Es könnte jedoch sein das diese Versionen unterschiedliche Versionen der "gems" benötigen - dies wird erst in zukünftigen Skript Versionen unterstützt.
In Zukunft soll dazu RVM eingesetzt werden, um verschiedene Ruby Environments für verschiedene Consul-Versionen erstellen zu können.

Derzeit werden alle gems unter /var/lib/gems gespeichert. Der Verweis auf die jeweilig für einen Benutzer installiertes gem findet sich auf ~/.gem

Es wird ein Benutzer und Gruppe "consul" angelegt (soferne noch nicht vorhanden)
Es wird ein Benutzer und Gruppe "ruby" angelegt. Jeder Benutzer der Ruby verwenden möchte, muss der Gruppe "ruby" hinzugefügt werden, sonst können keine gems installiert werden.
Der Benutzer "consul" wird als Mitglied der Gruppe "ruby" hinzugefügt und erhält damit Schreibrechte auf /var/lib/gems

Derzeit werden die Gems als (und somit für) den Benutzer "consul" installiert,

siehe auch : https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations

Grundlegende Verwendung
-----------------------

.. code-block:: bash

    # Grundlegende Verwendung

Danksagungen
------------

- Besonderen Dank an "Uncle Bob" Robert C. Martin, speziell für seine Bücher "Clean Code" und "Clean Architecture"

Beitragen
---------

Bitte forken Sie dieses Projekt und senden Sie uns Ihre Pull Requests für Erweiterungen oder Fehlerbehebungen
- `Bitte tragen Sie bei <https://github.com/bitranox/setup_consul_development/blob/master/CONTRIBUTING.md>`_

Lizenz
------

Diese Software ist lizensiert unter der `MIT Lizenz <https://de.wikipedia.org/wiki/MIT-Lizenz>`_

