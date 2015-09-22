# Statsd-Collectors
A collection of collectors, for deployment to (primarily windows) systems needing performance monitoring.

## Statsd-Collector.ps1

Modify **settings.xml** to suit your environment and the system you are deploying to. **statsd-collector.ps1** will send stats to the 'company.computername' namespace. If you modify this script to be run on one device that is monitoring another, you will need to modify the script to use an appropriate namespace. Currently it is written with the intent to collect stats on the local machine.
