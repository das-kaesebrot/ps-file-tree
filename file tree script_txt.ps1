Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
"@

#main

Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    SelectedPath = 'C:\'
}
[void]$FolderBrowser.ShowDialog()
[string]$targetDir = $FolderBrowser.SelectedPath


#$treeContent = Get-ChildItem -Path $targetDir -File -Name | Out-String;


$treeContent = tree $targetDir /F | Out-String;
$treeContent = $treeContent.Split("`n");
[string]$treeContentMultiLine = "";


# remove first two lines
for ($i=0;$i -lt $treeContent.Length;$i++)
{
    if ($i -le $treeContent.Length-2)
    {
        $treeContent[$i] = $treeContent[$i+2];
    }
    else 
    {
        $treeContent[$i] = "";
    }

# rejoin array into 1 multiline string    
    $treeContentMultiLine = ($treeContentMultiLine + $treeContent[$i]);

}


# testing the output
<#
for ($i=0;$i -lt $treeContent.Length;$i++) 
{
  Write-Host ($treeContent[$i]);
}
#>

# write variable to output for bug checking
#Write-Host ($treeContentMultiLine);

$file = ('Verzeichnisbaum' + '.txt');
$filepath = Join-Path $targetDir $file

#Write variable to file
$treeContentMultiLine | Out-File $filepath;

Invoke-Item $filepath

#Wait for keystroke to end program
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")