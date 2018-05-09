# fogscripts
## Comprehensive MDT &amp; FOG deployment / toolkit

Four pieces:

* MDT Build Environment:
  * Scheduled weekly MDT source updates - **easy, DONE**
    * Purge of Office installer - **easy, DONE**
    * Purge Ninite apps - **easy, DONE**
  * Scheduled weekly purge of outdated MDT sources - **moderate, DONE**
    * Download and import of Office installer via ODT - **moderate, DONE**
    * Download and import of specified Ninite apps - **moderate, DONE**
  * Update task sequence to new Office / Ninite - **difficult, DONE**
    * Update build task sequence with new Office - **difficult, DONE**
    * Update build task sequence with new Ninite - **difficult, DONE**
    * Rebuild of build deployment shares - **easy, DONE**
  * Capture WIM - *moderate*
    * Start capture VM - *easy*
    * Wait for finish - *easy*
  * Update deploy task sequence to new OS
    * Purge deployment OS - **easy, DONE**
    * Update deploy TS with new OS - **moderate, DONE**
    * Rebuild of FOG deployment shares - **easy, DONE**
  * Copy FOG deployment share from MDT to FOG - **easy, DONE**
  
* FOG Home Repo:
  * Git commit new MDT share - *easy*
  * Git commit FOG configuration changes - *easy*
  * Git push to cloud repo - *easy*
  
* FOG Cloud Repo:
  * Function as Git server for pushes from home - *easy*
  * Function as Git server for pulls from clients - *easy*
  
* FOG Client Servers:
  * Scheduled git pull from FOG cloud repo - *easy*
  * Symlink drivers in MDT share to FOG virtual driver store - **difficult, DONE**
    * Probably best to parse MDT "Out-of-Box Drivers" xml via Python - **difficult, DONE**
  * Script FOG vanilla deployment driver installation - **difficult, DONE**
  * Create "Boot to MDT" FOG task - **easy, DONE**
    * (Non-essential) Build to full fledged deployment task via APIs - *moderate*
  * FOG Advanced Tasks:
    * Enable & clear Windows local Administrator password - *easy*
    * Back up C:\Users to FOG share - *easy*
    * Boot to live Lubuntu with SSH and VNC running - *moderate*
    * Improve / chain [existing FOG advanced tasks](https://wiki.fogproject.org/wiki/index.php?title=Managing_FOG#Advanced_Tasks) into automated workflows - *moderate*
