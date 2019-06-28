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

----

Host System
-----------

Das Host System besteht aus einem Linux Betriebssystem Version 18.04 (bionic) oder 19.04 (disco) oder höher.
Die Basisinstallation kann entweder Linux Server (weniger Platzbedarf) oder Linux Desktop sein.
Es wird von einer frischen, minimalen Installation des Hostsystemes ausgegangen.
Es wird in weiterer Folge ein Desktop System (unser Vorschlag ubuntu-desktop-mate) installiert, um bequem auf die virtuelle LXC Maschine
über einen grafischen X-Client (x2go und/oder Chrome Remote Desktop) zugreifen zu können.
Wie immer bei Linux führen sehr viele Wege zum Ziel, hier wird versucht eine möglichst einfache, bequeme Variante zu Erstellen -
ohne Rücksicht auf optimierte Performance oder Ressourcen minimierung.

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

auf diese virtuelle Maschine installieren Sie nun ein Ubuntu Server oder Desktop - nur das notwendigste !

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

wir gehen davon aus das Betriebssystem läuft. Wechseln Sie auf die Konsole (Terminal).

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

dieses Skript führt ein Update der eigenen Installationsskripte durch. Achtung, etwaige eigene Änderungen in den Skripten werden überschrieben !

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
Installation von notwendigen Tools wie snap, geany, mc, meld, build-essential, synaptics

.. code-block:: bash

    cd ~/consul-dev-env-public/bin
    ./004*
