#Tape Expiration and Relabeling GUI APP 
#Created by Eric Laff
#Add Assembly
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#Create Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Tape GUI"
$Form.StartPosition = "CenterScreen"
$Label = New-Object System.Windows.Forms.Label
$Label.AutoSize = $True

#Add "Press Escape to exit" and "Hit enter to send input"
$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$Input.Text;$Form.Close()}})
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$Form.Close()}})

#Create Textbox
#$Input = New-Object System.Windows.Forms.TextBox
#$Input.Location = New-Object System.Drawing()



#Create Button
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(75,120) 
$Button.Size = New-Object System.Drawing.Size(75,23)
$Button.Text = "Submit" 
$Button.Add_Click({$x=$Input.Text})
$Form.Controls.Add($Button)

#Dropdown Combobox
$DropDown = new-object System.Windows.Forms.ComboBox
$DropDown.Location = new-object System.Drawing.Size(100,10)
$DropDown.Size = new-object System.Drawing.Size(130,30)
[array]$DropDownArray = "Expire", "Relabel"
$UserSelect1 = $DropDownArray[0]
$UserSelect2 = $DropDownArray[1]
#Dropdown Function that is called when the button is clicked
function DropDownChoice (){


$Selected = $Dropdown.SelectedItem.ToString()
#Determines which choice is made via the combobox
#Expire
if ($Selected -eq $UserSelect1){
#Loops through the text doc and creates an array of all tape numbers
for ($i = 0;$i -le $tapes.length;$i++ ){
cd D:\Veritas\Netbackup\bin\admincmd | bpexpdate -m $tapes[$i] -d 0 -host bkup41ny1us01 -force

$Date =  Get-Date -Format "'Expired On:'MMM/dd/yy" | Add-Content 'C:\Users\lafferic\Desktop\Tape Log.txt'
$Log = Get-Content -Path 'C:\Users\lafferic\Desktop\Tapes.txt' | Add-Content -Path 'C:\Users\lafferic\Desktop\Tape Log.txt'
}
}
#Relabel
elseif ($Selected -eq $UserSelect2){
#Loops through the text doc and creates an array of all tape numbers
cd D:\Veritas\Netbackup\bin\admincmd | bplabel -ev $tapes[$i] -d hcart3 -p Scratch

$Date =  Get-Date -Format "'Expired On:'MMM/dd/yy" | Add-Content 'C:\Users\lafferic\Desktop\Tape Log.txt'
$Log = Get-Content -Path 'C:\Users\lafferic\Desktop\Tapes.txt' | Add-Content -Path 'C:\Users\lafferic\Desktop\Tape Log.txt'


}
}


#Loops through and adds the strings to the combobox(dropdown menu)
ForEach ($Item in $DropDownArray) {
$DropDown.Items.Add($Item)
}
$Button.Add_Click({DropDownChoice})



$DropDown.SelectedItem = $DropDown.Items[0]
$Form.Controls.Add($DropDown)

$DropDownLabel = new-object System.Windows.Forms.Label
$DropDownLabel.Location = new-object System.Drawing.Size(10,10) 
$DropDownLabel.size = new-object System.Drawing.Size(100,40) 
$DropDownLabel.Text = "Select Action for the Tape"
$Form.Controls.Add($DropDownLabel)




#Build Form
$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()