# Necessary info for mapping drives to azure file shares
# written by: github/stolig 
# This will remove any mapped drives that use drive letters specified in $shareList , then map them to the shares specified in $shareList


$myStorageAccount = @{"AZURE\myusername"="longAccessKeyFromStorageAccount"}
$shareList = @{"share1"="G";"share2"="J";"share3"="K"}

$myStringUsername = $myStorageAccount.Keys
[string]$password = $myStorageAccount.values
$myAccountName = $myStringUsername.substring(6) # shaving AZURE\ off the front...
[string]$serverPath = "$myAccountName" + ".file.core.windows.net"

$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $myStringUsername, $securePassword

#delete the cmdkey / windows credential manager creds if needed:
#Invoke-Expression -Command ("cmdkey /delete:$serverPath")

function addCreds() {

	$myCurrentCreds = Invoke-Expression -Command ("cmdkey /list")
	
	foreach ($oneLine in $myCurrentCreds) {
	
		$credList += $oneLine
	
	}
	
	foreach ($oneCurrentShare in $myStorageAccount) {
		
		if (! $credList.contains($myStringUsername)) {
				
			write-host "You need to create creds for: "$myStringUsername
			
			[string]$myStringPassword = [string]$oneCurrentShare.values
			
			Invoke-Expression -Command "cmdkey /add:$serverPath /user:$myStringUsername /pass:$myStringPassword"
			
		}
		
		else {
		
			write-host $myStringUsername " already exists in cmdkey on this machine"
		
		}
	
	}
	
	mapDrive

}

function mapDrive {
	
	foreach ($oneShare in $shareList.GetEnumerator()) {
		
		[string]$strShareName = $oneShare.name
		[string]$strShareValue = $oneShare.value
		
		# remove any drive with the same name
		
		remove-psdrive $strShareValue 2>$null
		
		# add your new mapped drive to azure share:

		New-PSDrive -Name "$strShareValue" -PSProvider FileSystem -Root "\\$serverPath\$strShareName" -Persist -Scope Global 2>$null #-Credential $credential
			
	}

}

addCreds
