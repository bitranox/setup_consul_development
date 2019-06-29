Erstellen einer Consul Entwicklungsumgebung - PUBLIC
====================================================

|license| |maintenance|

|Build Status| |Codecov Status| |Better Code| |code climate| |snyk security|

.. |license| image:: https://img.shields.io/github/license/webcomics/pywine.svg
   :target: http://en.wikipedia.org/wiki/MIT_License
.. |maintenance| image:: https://img.shields.io/maintenance/yes/2019.svg
.. |Build Status| image:: https://travis-ci.org/bitranox/consul-dev-env-public.svg?branch=master
   :target: https://travis-ci.org/bitranox/consul-dev-env-public
.. |Codecov Status| image:: https://codecov.io/gh/bitranox/consul-dev-env-public/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/bitranox/consul-dev-env-public
.. |Better Code| image:: https://bettercodehub.com/edge/badge/bitranox/consul-dev-env-public?branch=master
   :target: https://bettercodehub.com/results/bitranox/consul-dev-env-public
.. |snyk security| image:: https://snyk.io/test/github/bitranox/consul-dev-env-public/badge.svg
   :target: https://snyk.io/test/github/bitranox/consul-dev-env-public
.. |code climate| image:: https://api.codeclimate.com/v1/badges/ff3f414903627e5cfc35/maintainability
   :target: https://codeclimate.com/github/bitranox/consul-dev-env-public/maintainability
   :alt: Maintainability

Die hier vorgestellten Skripte dienen zur Einrichtung einer Standardisierten Entwicklungsumgebung für Consul unter Ruby.
Über diese Skripte wird entweder auf einem Linux Host, oder auf einer virtuellen Maschine (VM-Ware) ein LXC Container (dies ist eine weitere virtuelle Maschine) erstellt.
Es wird alle Software installiert um Consul auszuführen (Entwicklungs & Testumgebung - keine Produktionsumgebung, diese hat andere, höhere Voraussetzungen !)

Getestet unter: Ubuntu 18.04 (bionic), Ubuntu 19.04 (disco) jeweils in der minimalen installation Deutsch, entweder direkt auf einem Rechner installiert (bevorzugt) oder auf einer virtuellen Maschine.

----

- `Voraussetzungen`_
- `Installation`_
- `Grundlegende Verwendung`_
- `Danksagungen`_
- `Beitragen`_
- `Probleme melden <https://github.com/bitranox/consul-dev-env-public/blob/master/ISSUE_TEMPLATE_de.md>`_
- `Pull Request <https://github.com/bitranox/consul-dev-env-public/blob/master/PULL_REQUEST_TEMPLATE_de.md>`_
- `Verhaltenskodex für Mitwirkende <https://github.com/bitranox/consul-dev-env-public/blob/master/CODE_OF_CONDUCT_de.md>`_
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
    - `000_update_myself`_
    - `001_install_languagepack`_
    - `003_remove_unnecessary`_
    - `004_install_tools`_
    - `005_install_lxd_container_system`_
    -  BIS HIER GETESTET NACHFOLGENDES FUNKTIONIERT NOCH NICHT
    - `006_configure_lxd_container_system`_
    - `007_create_clean_lxc_container`_

----

Die Ruby Entwicklungsumgebung läuft auf Ubuntu Desktop 19.04 (Disco Dingo) oder höher - andere Versionen können funktionieren,
sind aber im Moment nicht getestet !


Folgende Installationsvarianten sind möglich:

----

Installationsvarianten
----------------------

Es gibt verschiedene Varianten um eine Produktionsumgebung zu erreichen :

wir schlagen vor die Entwicklungsumgebung auf dem Hostsystem Ubuntu 19.04 in LXC Containern laufen zu lassen.
Diese Container können sehr leicht für diverse Tests geklont werden, auch Cluster mit mehreren parallel laufenden LXC Containern sind leicht möglich.

Das Hostsystem kann wiederum in einer Virtuellen Maschine (VMWare) laufen.

Die Ruby Entwicklungsumgebung kann auch direkt auf dem Hostsystem installiert werden. Wie auch immer - wir empehlen die Verwendung von LXC Containern.


Host System
-----------

Das Host System besteht aus einem Linux Desktop Betriebssystem.
Wenn Sie LXC Container installieren möchten (empfohlen) so wird Version 19.04 (disco) benötigt - 18.04 funktioniert NICHT.
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

    # wechsel in das Home Verzeichnis
    cd ~
    # install git
    sudo apt-get install git -y
    # Herunterladen der Skripte
    git clone https://github.com/bitranox/consul-dev-env-public.git
    # Skripte ausführbar machen
    sudo chmod -R +x ./consul-dev-env-public/bin/*.sh


die Skripte befinden sich nun im Verzeichnis Home/consul-dev-env-public/bin und müssen von dort aufgerufen werden.
Dies können Sie händisch in der Konsole machen, oder über einen Dateimanager (Nautilus, Caja, etc...) aufrufen.

Die Skripte sind nummeriert und lassen sich so leicht auch manuell aufrufen :

.. code-block:: bash

    # wechsel in das Skript Verzeichnis
    cd ~/consul-dev-env-public/bin

    # Aufruf des Skriptes 000_update_myself.sh
    # so können Sie sehr schnell die Skripte ohne große Tipparbeit in der Konsole ausführen
    # alternativ können Sie natürlich sie Skripte über den Dateimanager starten
    ./000*



Essentielle, automatisch Installierte Programme
-----------------------------------------------

folgende Programme werden bei Verwendung dieser Skripte automatisch, ohne Rückfrage installiert:

- net-tools (grundlegende Netzwerk Tools)
- git

000_update_myself
-----------------

Dieses Skript führt ein Update der eigenen Installationsskripte durch. Achtung, etwaige eigene Änderungen in den Skripten werden überschrieben !

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./000*

001_install_languagepack
------------------------

Installation des Deutschen Sprachpaketes für Linux. Auch wenn Sie es vielleicht bereits haben - es schadet nicht.

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./001*

002_install_ubuntu_mate_desktop
-------------------------------
Für Ubuntu-Desktop Versionen OPTIONAL, für Ubuntu Server zwingend notwendig !

Installation des Ubuntu-Mate-Desktops - diese Desktopumgebung ist mehr Windows-ähnlich,
viele Leute (so auch ich) kommen mit dem neuen Ubuntu-Gnome Desktop nicht so gut zurecht.

Die Netzwerksettings unter /etc/netplan/ werden automatisch auf Netzwerkmanager geändert!

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./002*

003_remove_unnecessary
----------------------
Für die Entwicklung unnötige Programme deinstallieren. Darunter fallen viele Tools wie VIM, Brasero, aber auch
Thunderbird Mailprogramm, Dateimanager Nautils (Mate verwendet Caja), oder Libre Office.
Führen Sie dieses Script nur dann aus, wenn Sie SICHER sind das Sie keines dieser Programme benötigen !

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./003*

004_install_tools
-----------------
Installation von notwendigen Tools wie snap, geany, mc, meld, build-essential, synaptics, x2goclient

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./004*

005_install_lxd_container_system
--------------------------------
Installation des LCD Container Systemes (nur wenn Sie LXC Container verwenden möchten)

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./005*

006_configure_lxd_container_system
----------------------------------
Konfiguration des LXC Systemes (nur wenn Sie LXC Container verwenden möchten)
 - anlegen eines Shared Directories zum Dateiaustausch unter $HOME/lxc-shared
 - Disk Device zu Shared Directory zu Profile "default" hinzufügen
 - subuid, subgid setzen
 - raw idmap im profile setzen (für Zugriffsberechtigung auf Shared Directory)
 - lcx network bridge DNS Zone .lxd einrichten (die container sind dann im DNS unter <containername>.lxd eingetragen
 - systemd-resolved konfigurieren, DNS Zone .lxd wird auf der lxdbr0 Bridge abgefragt

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./006*

007_create_clean_lxc_container
------------------------------
Erzeugen des ersten LXC Containers (nur wenn Sie LXC Container verwenden möchten)
Erzeuge einen sauberen LXC Container lxc-clean, mit Benutzer consul, passwort consul.
Dieser Container ist dann über den X2GO Client über die Adresse lxc-clean.lxd erreichbar.
(auch über SSH, etc)

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./007*

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
- `Bitte tragen Sie bei <https://github.com/bitranox/consul-dev-env-public/blob/master/CONTRIBUTING.md>`_

Lizenz
------

Diese Software ist lizensiert unter der `MIT Lizenz <https://de.wikipedia.org/wiki/MIT-Lizenz>`_

