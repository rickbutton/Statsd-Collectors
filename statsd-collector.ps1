$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path

#Import email settings from config file
[xml]$ConfigFile = Get-Content "$myDir\settings.xml"

$server = $ConfigFile.Settings.StatsdServer
$port = $ConfigFile.Settings.StatsdPort
$customer = $ConfigFile.Settings.Customer
$drives = $ConfigFile.Settings.Drives

$computername = (hostname).ToLower()
$namespace = "{0}.{1}" -f $customer, $computername


# Get Disk Space Info
Get-WmiObject Win32_LogicalDisk -ComputerName localhost | ForEach-Object {
	$deviceid = $_.DeviceID.Substring(0,1).ToLower()
	if($drives.Contains($deviceid)) {
		$freespace = [math]::round($_.FreeSpace / 1GB,2)
		$size = [math]::round($_.Size / 1GB,2)
		$percent = $freespace / $size

		./send-statsd -data "$namespace.disk.$deviceid.freespace:$freespace|g" -ip $server -port $port
		./send-statsd -data "$namespace.disk.$deviceid.size:$size|g" -ip $server -port $port
		./send-statsd -data "$namespace.$deviceid.percent-free:$percent|g" -ip $server -port $port
	}
}

# Get RAM Info

$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem
$TotalMem = $ComputerSystem.TotalPhysicalMemory/1mb
$OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem
$FreeMem = ([math]::round($OperatingSystem.FreePhysicalMemory / 1024, 2))

./send-statsd -data "$namespace.memory.total:$TotalMem|g" -ip $server -port $port
./send-statsd -data "$namespace.memory.free:$FreeMem|g" -ip $server -port $port
