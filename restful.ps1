$data = Invoke-RestMethod -Method Get -Uri 'https://prtg//api/table.xml?content=devices&output=csvtable&columns=device,host&username=USERNAME&password=PASSWORD'
