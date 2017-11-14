#Tape Expiration and Relabeling GUI APPLICATION Symantec Backup Tape System
#Created by Eric Laff

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#Create Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Tape Expiration/Relable GUI"
$Form.StartPosition = "CenterScreen"
$Label = New-Object System.Windows.Forms.Label
$Label.AutoSize = $True
$Form.Height = 350
$Form.Width = 600

#Create Button
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(10,10) 
$Button.Size = New-Object System.Drawing.Size(75,23)
$Button.Text = "Submit" 
$Button.Add_Click({$x=$Input.Text})
$Form.Controls.Add($Button)

#Add "Press Escape to exit" and "Hit enter to send input"
$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$Input.Text;$Form.Close()}})
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$Form.Close()}})


#Create Textbox
$outputBox = New-Object System.Windows.Forms.RichTextBox #creating the text box
    $outputBox.Location = New-Object System.Drawing.Size(5,50)
    $outputBox.Size = New-Object System.Drawing.Size(565,200)
    $outputBox.MultiLine = $True
    $outputBox.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor 
                    [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
    $outputBox.ScrollBars = "Vertical"
    $outputBox.Font = New-Object System.Drawing.Font("Trebuchet MS",14)
    $outputBox.ForeColor = [Drawing.Color]::White
    $outputBox.BackColor = '#001a66'
    
    $Form.Controls.Add($outputBox) 

#Dropdown Combobox
$DropDown = new-object System.Windows.Forms.ComboBox
$DropDown.Location = new-object System.Drawing.Size(380,10)
$DropDown.Size = new-object System.Drawing.Size(130,10)
$DropDownArray = @("Expire","Relabel")
$UserSelect1 = $DropDownArray[0]
$UserSelect2 = $DropDownArray[1]





#$DirectoryCommand =  "cd D:\Veritas\Netbackup\bin\admincmd"
#$ExpireCommand =  ".\bpexpdate -m $i -d 0 -host bkup41ny1us01 -force"
#$RelabelCommand =  ".\bplabel -ev $i -d hcart3 -p Scratch" 



#Dropdown Function that is called when the button is clicked
function DropDownChoice{
###########################Error Checks###########################################k

$outputBox.Text = "Starting... `n"

$Selected = $DropDown.SelectedItem.ToString()
$ClearArray
$ClearOutput
$ClearOutput = Clear-Content -Path C:\Users\lafferic\Desktop\Incorrect-Tapes.txt
$ClearArray = $IncorrectArray.clear()
$tapes = Get-Content C:\Users\lafferic\Desktop\Tapes.txt 
$tapesArray = New-Object System.Collections.ArrayList
$IncorrectArray = New-Object System.Collections.ArrayList
[Collections.Generic.List[String]]$IncorrectArray
foreach ($i in $tapes -notmatch "L5")
{
$IncorrectArray.Add($i)
}
foreach ($i in $tapes -match "L5")
{
$tapesArray.Add($i)
if ($i.Length -ne 6)
{
$IncorrectArray.Add($i)
$tapesArray.Remove($i)
}elseif ($i -like "* *")
{
$IncorrectArray.Add($i)
$tapesArray.Remove($i)
}elseif ($i -match "[a-z]^[A-Z]")
{
$IncorrectArray.Add($i)
$tapesArray.Remove($i)
}
}
Add-Content C:\Users\lafferic\Desktop\Incorrect-Tapes.txt $IncorrectArray
########End of Error Check##################################################



#Determines which choice is made via the combobox
#Expire

if ($Selected -eq $UserSelect1){
$outputBox.Text += "Starting Expiration Process.... `n"
foreach ($i in $tapesArray){
#Loops through the text doc and creates an array of all tape numbers
$CMD = "cmd.exe"
  cd D:\Veritas\Netbackup\bin\admincmd
 .\"bpexpdate -m $i -d 0 -host bkup41ny1us01 -force"
Start-Process  -Verb runas $CMD -WindowStyle Hidden
$Process = Write-Output "Expiring Tape " $i "`n"
$outputBox.Text += $Process

}

}elseif ($Selected -eq $UserSelect2)
{
$outputBox.Text += "Starting the Relabeling Process.... `n"
foreach($i in $tapesArray){
 cd D:\Veritas\Netbackup\bin\admincmd
.\bplabel -ev $i -d hcart3 -p Scratch
Start-Process -Verb runas $CMD -WindowStyle Hidden
$RelabelingProcess += Write-Output "Relabeling Tape" $i "`n" 
$outputBox.Text += $RelabelingProcess

}
}
$Finished += Write-Output "Finished" $Selected"ing" "`n"
$outputBox.Text += $Finished
}

###########End Of Function##############################################
$Date =  Get-Date -Format "'Expired/Relabled On:'MMM/dd/yy" | Add-Content 'C:\Users\lafferic\Desktop\Tape Log.txt'
$Log = Get-Content -Path 'C:\Users\lafferic\Desktop\Tapes.txt' | Add-Content -Path 'C:\Users\lafferic\Desktop\Tape Log.txt' 
#Loops through and adds the strings to the combobox(dropdown menu)
ForEach ($Item in $DropDownArray) {
$DropDown.Items.Add($Item)
}



 
$DropDown.SelectedItem = $DropDown.Items[0]
$Form.Controls.Add($DropDown)

$DropDownLabel = new-object System.Windows.Forms.Label
$DropDownLabel.Location = new-object System.Drawing.Size(150,10) 
$DropDownLabel.size = new-object System.Drawing.Size(200,40) 
$DropDownLabel.Text = "Please Select An Action for the Tape Press Submit When Ready to Process the Media"
$Form.Controls.Add($DropDownLabel)

#$outputResults = DropDownChoice

$Button.Add_Click({DropDownChoice})


#$outputBox.AppendText($outputResults)
#$Button.Add_Click({
#$outputBox.AppendText($outputResults) })
#$Button.Add_Click({$outputBox.AppendText($UserSelect1)})

#Build Form
$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()



