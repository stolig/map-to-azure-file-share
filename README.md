# map-to-azure-file-share
Map drives automagically to a azure file shares on the same storage account using group policy and powershell

In gpo / group policy, your context / environment matters. You need to run this in the current user's context. Example: make a sheduled task login script that uses the user's context 'Run only when user is logged on' and 'When running the task, use the following user account: %LogonDomain%\%LogonUser% . Then for the 'action' of the scheduled task login script: point to powershell with your desired arguments for running the powershell. Example: -NoProfile -executionpolicy Unrestricted -WindowStyle Hidden -File \\servername\fileshare\map-azure-file-share.ps1

...or - just run the powershell script while you're logged in if you don't need automation...but who doesn't need automation?!
