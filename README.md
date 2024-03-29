# vlc-audio-recorder-windows-powershell
Windows Powershell audio recorder via VLC allowing for recording of subsequent audio files based on configuration.

## Schedule via Windows Scheduler

NOTE: Some of these settings may need to be adjusted per your specific setup and use.

- Open `Task Scheduler`
- Click `Create Task...`
- On the `General` tab
    - Enter a name
    - Select `Run whether user is logged on or not`
    - Check `Run with highest privileges`
    ![image](https://user-images.githubusercontent.com/7319505/148479711-a6e3b548-7083-4caa-a211-d51b946552fc.png)
- On the `Triggers` tab
    - Configure as desired based on timming, login, idle, events, or other triggers.
    - Ensure the `Enabled` checkbox is checked
    ![image](https://user-images.githubusercontent.com/7319505/148479758-08e30fb0-1aec-4187-8dd8-cc8cb2adf1ae.png)
- On the `Actions` tab, click `New`
    - Set `Action` to `Start a program`
    - In `Program/script:` enter `powershell`
        - You could also set the full path to the Powershell application, which on Windows 10 should be `%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe`
    - In `Add arguments (optional):` enter the command arguments that Powershell will run.
        - Example: `-File C:\<path_to_file>\audio-record-via-vlc.ps1 -duration 60 -clips 1 -destination "C:\<path_to_save_audio_clips_to>" -clipNumberOffset -1 -fileName "open_{year}"`
        - Argument: **-File** The path to this audio recorder script on your local computer
        - All the other arguments are specific to this program and are listed below

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
        
        NOTE: do not end with a trailling slash.

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
        Default value                https://corn.kvsc.org/broadband

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
