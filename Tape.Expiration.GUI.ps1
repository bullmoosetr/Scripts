#ERASE ALL THIS AND PUT XAML BELOW between the @" "@ 
$inputXML = @"
<Window x:Class="WpfApplication1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MainWindow" Height="258.478" Width="424.261">
    <Grid x:Name="Tape_Expiration_Relabel_GUI" Margin="0,0,46,44">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="34*"/>
            <ColumnDefinition Width="151*"/>
        </Grid.ColumnDefinitions>
        <TextBox x:Name="Input" Grid.Column="1" HorizontalAlignment="Left" Height="21" Margin="38,101,0,0" TextWrapping="Wrap" Text="Enter Number Here" VerticalAlignment="Top" Width="184" Background="White">
            <TextBox.BorderBrush>
                <LinearGradientBrush EndPoint="0.5,1" MappingMode="RelativeToBoundingBox" StartPoint="0.5,0">
                    <GradientStop Color="#FFE2E3EA" Offset="1"/>
                    <GradientStop Color="#FFABADB3" Offset="1"/>
                    <GradientStop Color="Black" Offset="0.976"/>
                    <GradientStop Color="Black"/>
                </LinearGradientBrush>
            </TextBox.BorderBrush>
        </TextBox>
        <Button x:Name="Submit" Content="Submit" Grid.Column="1" HorizontalAlignment="Left" Margin="91,154,0,0" VerticalAlignment="Top" Width="75" Height="22"/>
        <TextBlock Grid.Column="1" HorizontalAlignment="Left" Height="45" Margin="10,10,0,0" TextWrapping="Wrap" Text="Please enter your 6 Digit tape number in the input box below. Then press the submit button." VerticalAlignment="Top" Width="275"/>
        <ComboBox x:Name="dropdown_menu" Grid.Column="1" HorizontalAlignment="Left" Height="21" Margin="75,60,0,0" VerticalAlignment="Top" Width="106">
            <ListBoxItem Content="Expire"/>
            <ListBoxItem Content="Relabel"/>
        </ComboBox>

    </Grid>
</Window>
"@       
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Actually make the objects work
#===========================================================================
$WPFSubmit.Add_Click({
$userInput = $WPFInput.Text
$dropDown = $WPFdropdown_menu

#User selects from the dropdown menu

"Hello, World!"

})
#User clicks submit
    #users list of tape numbers are grabed from text file
    
    #checks to make sure all tape number are 6 digits
    
    #sends success message
    
    #sends failure message

 

 
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
'$Form.ShowDialog() | out-null'

#============================================================================
#Objects and Arguments
#============================================================================
