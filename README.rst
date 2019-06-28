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

- `Host System`_
- `mit virtueller Maschine`_
- `ohne virtueller Maschine`_
- `Installation der Skripte`_
- `Essentielle, automatisch Installierte Programme`_

----

Host System
-----------

Das Host System besteht aus einem Linux Betriebssystem Version 18.04 (bionic) oder 19.04 (disco) oder höher.
Die Basisinstallation kann entweder Linux Server (kleiner) oder Linux Desktop sein.
Es wird von einer frischen, minimalen Installation des Hostsystemes ausgegangen.

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
    sudo chmod -R +x ./consul-dev-env-public/*.sh


die Skripte befinden sich nun im Verzeichnis Home/consul-dev-env-public/bin und müssen von dort aufgerufen werden.
Dies können Sie händisch in der Konsole machen, oder über einen Dateimanager (Nautilus, Caja, etc...) aufrufen.


Essentielle, automatisch Installierte Programme
-----------------------------------------------

folgende Programme werden bei Verwendung dieser Skripte automatisch, ohne Rückfrage installiert:

- net-tools (grundlegende netzwerk Tools)
- git
- mc  (Midnight Commander, ein Text Basierender Dateimanager und Editor, Aufruf mit "mc" oder "sudo mc")

folgende Programme werden bei Verwendung dieser Programme automatisch ohne Rückfrage deinstalliert:

- whoopsie  (Meldung von Fehlern an Ubuntu - das nervt)
- apport    (Meldung von Fehlern an Ubuntu - das nervt)

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

