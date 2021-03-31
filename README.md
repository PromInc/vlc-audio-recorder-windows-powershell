# vlc-audio-recorder-windows-powershell
Windows Powershell audio recorder via VLC allowing for recording of subsequent audio files based on configuration.


## SYNTAX
    C:\path\to\audio-record-via-vlc.ps1 [[-clips] <Int32>] [[-duration] <Int32>] [[-pauseBetween] <Int32>] [-destinationPath] <String> [[-fileName] <String>] [[-streamUrl] <String>] [[-vlcLocation]
    <String>] [[-clipNumberOffset] <Int32>] [[-overwrite] <Boolean>] [<CommonParameters>]


## DESCRIPTION
    Record a specified number of audio clips from a specified stream at specified times.

    Output files are in the .mp3 format.

    This script requries that VLC is installed on your system.
    https://www.videolan.org/vlc/download-windows.html


## PARAMETERS
    -clips <Int32>
        How many clips to record.

        Required?                    false
        Default value                50

    -duration <Int32>
        How long each clip is in seconds.

        Required?                    false
        Default value                3600

    -pauseBetween <Int32>
        How long pause between each clip in seconds.

        Required?                    false
        Default value                0

    -destinationPath <String>
        File path to save output clips to.

        A dynamic parameter of {year} can be added and will be replaced by the current year.

        If the directory does not exist, it will be created.

        Required?                    true
        Default value

    -fileName <String>
        File name for output audio clips.

        If not specificed, they will be numbered .mp3 files only.

        A dynamic parameter of {year} can be added and will be replaced by the current year.

        Required?                    false
        Default value

    -streamUrl <String>
        Audio stream URL to record.

        Required?                    false
        Default value                http://corn.kvsc.org:8000/broadband.m3u

    -vlcLocation <String>
        Path to VLC exe file.
        If not set, uses the default program files location..

        Required?                    false
        Default value

    -clipNumberOffset <Int32>
        A numeric offset for the file numbering scheme.
        By default the first clip will be number 1.
        Examples:
        clipNumberOffset = -1, first clip number = 0
        clipNumberOffset = 5, first clip number = 5

        Required?                    false
        Default value                0

    -overwrite <Boolean>
        If true, overwrite file names in the destinationPath
        If false (default), increment after the highest numeric file in the directory.

        Required?                    false
        Default value                False

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS
    Network audio stream as specified by the streamUrl parameter


## OUTPUTS
    mp3 files to specified destinationPath parameter



## VLC Download (required)
    https://www.videolan.org/vlc/download-windows.html