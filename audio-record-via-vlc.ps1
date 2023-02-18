# How to automate via Windows Scheduler:
#  https://blog.netwrix.com/2018/07/03/how-to-automate-powershell-scripts-with-task-scheduler/
# Example command for Windows Scheduler:
#  -File C:\Users\promi\Documents\audio-record-via-vlc.ps1 -destinationPath " C:\Users\promi\Documents\audio-clips\"

# In Windows Security "Allow an app through Controlled folder access" Allow app Powershell (C:\Windows\System32\WindowsPowerShell\v1.0)

# Version 1.1.0

# TODO: Add crash detection and restart the script/recording as needed

<#
.Description
Record a specified number of audio clips from a specified stream at specified times.

Output files are in the .mp3 format.

This script requries that VLC is installed on your system.
https://www.videolan.org/vlc/download-windows.html
.PARAMETER destinationPath
File path to save output clips to.

A dynamic parameter of {year} can be added and will be replaced by the current year.

If the directory does not exist, it will be created.

NOTE: do not end with a trailling slash.
.PARAMETER fileName
File name for output audio clips.

If not specificed, they will be numbered .mp3 files only.

A dynamic parameter of {year} can be added and will be replaced by the current year.
.PARAMETER clips
How many clips to record.
.PARAMETER duration
How long each clip is in seconds.
.PARAMETER pauseBetween
How long pause between each clip in seconds.
.PARAMETER streamUrl
Audio stream URL to record.
.PARAMETER vlcLocation
Path to VLC exe file.
If not set, uses the default program files location..
.PARAMETER clipNumberOffset
A numeric offset for the file numbering scheme.
By default the first clip will be number 1.
Examples:
clipNumberOffset = -1, first clip number = 0
clipNumberOffset = 5, first clip number = 5
.PARAMETER overwrite
If true, overwrite file names in the destinationPath
If false (default), increment after the highest numeric file in the directory.
.INPUTS
Network audio stream as specified by the streamUrl parameter
.OUTPUTS
mp3 files to specified destinationPath parameter
.LINK
https://www.videolan.org/vlc/download-windows.html
#>

# user specified parameters
param (
		[int] $clips = 50,
		[int] $duration = 3600,
		[int] $pauseBetween = 0,
		[Parameter(Mandatory)][string] $destinationPath,
		[string] $fileName = "",
		[string] $streamUrl = "https://corn.kvsc.org/broadband",
		[string] $vlcLocation = "",
		[int] $clipNumberOffset = 0,
		[bool] $overwrite = $false
	  )

# hard coded parameters
$outputExtension = ".mp3"
$bitrate = 128
$channels = 2

# get current year to write to that directory in the destinationPath
$year = Get-Date -UFormat %Y;

$destinationPath = $destinationPath.Replace( "{year}", $year )

# create directory if not exists
$makeDir = [System.IO.Directory]::CreateDirectory($destinationPath)

# get VLC directory
if( $vlcLocation.length -eq 0 ) {
	$programFiles = ${env:ProgramFiles};
	if($programFiles -eq $null) { $programFiles = $env:ProgramFiles; }
	$vlcLocation = $programFiles + "\VideoLAN\VLC\vlc.exe"
}

# Build filename
$fileName = $fileName.Replace( "{year}", $year )
$fileNamePrefix = $fileName
if( $fileName.length -gt 0 ) {
	$fileName = -join($fileName, "_");
}

# If directory has files already, use the latest file number as the basis for naming
$priorClipId = 0
if( $overwrite -eq $false -Or ($overwrite).tostring().ToLower() -eq "false" ) {
	$dirFiles = Get-ChildItem -Path $destinationPath -Recurse | Where-Object {$_.name -match "^$fileName([0-9]+)$outputExtension$"} | Sort-Object -Descending | select name -first 1
	if( $dirFiles ) {
		$priorClipId = ([int]$matches[1])
	}
}

# determine how many zeros to pad filename with
$padLength = ($clips + $priorClipId).tostring().length
if( ([int]$padLength) -lt 2 ) {
	$padLength = 2;
}

for ($clip = 1; $clip -le $clips; $clip++) {
	$fileNumber = ([string]($priorClipId + $clip + $clipNumberOffset)).PadLeft($padLength,'0')

	$outputFileName = [System.IO.Path]::Combine( $destinationPath, -join($fileName, $fileNumber, $outputExtension) );

	Write-Host "Recording $duration seconds of audio from $streamUrl for clip $clip for year $year to file $outputFileName"

	$processArgs = "`"$streamUrl`" --sout=#transcode{acodec=`"mp3`",ab=`"$bitrate`",`"channels=$channels`"}:standard{access=`"file`",mux=`"wav`",dst=`"$outputFileName`"} :no-sout-all :sout-keep --stop-time=$duration vlc://quit"

	start-process $vlcLocation $processArgs -wait

	# add delay between clips
	Start-Sleep -s $pauseBetween
}
