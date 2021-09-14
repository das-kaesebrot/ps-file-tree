Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
"@

# TODO Doesn't work yet!!

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


$file = ('Verzeichnisbaum' + '.png');
$filepath = Join-Path $targetDir $file

<#
#Write variable to file
$treeContentMultiLine | Out-File $filepath;
#>

[double]$scale=0.5;
[int]$imgWidth = 0;
[int]$imgHeight = 0;
#$imgHeight = ((($treeContent.Length)*32*$scale)+20+($scale*32*2));
$treeContentNEW = $treeContentMultiLine.Split("`n");

<#
foreach ($line in $treeContentNEW)
{
    if($line.Length -gt $imgWidth)
    {
        $imgWidth = $line.Length;
    }
}
$imgWidth = ((($imgWidth)*$scale)+20);
#>
$fontsize = $scale * 30;
Add-Type -AssemblyName System.Drawing

$font = new-object System.Drawing.Font Consolas,$fontsize
$brushBg = [System.Drawing.Brushes]::White 
$brushFg = [System.Drawing.Brushes]::Black 
$graphics = [System.Drawing.Graphics]::FromImage($bmp) 
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height) 

[float]$rectPosX=0;
[float]$rectPosY=0;
$spacing=0.1;

for ($i=0;$i -lt $treeContent.Length;$i++)
{
    $stringSize = new-object System.Drawing.SizeF 0,0;
    $stringSize = $graphics.Graphics.MeasureString($treeContent[$i], $font)
    $imageHeight = $imageHeight + $stringSize.Height();
    $graphics.DrawString($treeContent[$i],$font,$brushFg,10,$rectPosY)   
}
$graphics.Dispose();
$bmp = new-object System.Drawing.Bitmap $imgWidth,$imgHeight;
write-host ("Image Dimensions: " + $imgWidth + "x" + $imgHeight);
$bmp.Save($filepath);

#Show generated image
Invoke-Item $filepath;

#Wait for keystroke to end program
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")