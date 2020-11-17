#$filepath = 'C:\Temp\1469503234.csv'
#$Address = Invoke-WebRequest -Uri "https://sheet.best/api/sheets/4add3fb5-88bc-4a6a-8ed7-52579b67967e" | ConvertFrom-Json

$outfile = ".\Outfile.csv"
$maks = ".\maks.csv"
$newcsv = {} | Select "NameFull","PhoneNumber","AddressLine1","City","DemographicsGender","OwnRent","MaritalStatus","ChildrenAgeRange","DateOfBirth","DateOfDeath" | Export-Csv $outfile
$newcsvmaks = {} | Select "MAK" | Export-Csv $maks
$Addresses = Import-Csv -Path ".\Addresses.csv"
$City = 'Arlington'

foreach ($a in $Addresses | select -ExpandProperty Street) {
    $headers=@{}
    #$json = Invoke-WebRequest -Uri "https://api.versium.com/v1.0/address?campaign=BASIC&address=$A&city=Arlington&state=TX&country=US&key=b0178d5b-f0d8-48ce-9a87-1a66da31d914" -Method GET -Headers $header
    $json2 = Invoke-WebRequest -Uri "https://www.melissa.com/v2/lookups/addresssearch/?number=&street=$a+Ct&city=$City&state=TX&zip=&freeForm=Pompano+%0D%0APantego+TX&fmt=json&id=lLqW0h1QWDvdbhZxF0rJy0**nSAcwXpxhQ0PC2lXxuDAZ-**" -Method GET -Headers $header
    $jsonobj1 = $json2.content | ConvertFrom-Json
    $table2 = $jsonobj1 | ForEach-Object {
        [PSCustomObject] @{
            MAK = $_.MAK
        }
    }
    $table2 | Export-CSV $maks –Append -NoTypeInformation
    $table2 | Format-Table -AutoSize
}
$MAKSS = Import-Csv -Path $maks
foreach ($Mak in $MAKSS | select -ExpandProperty MAK) {
    $headers=@{}
    #$json = Invoke-WebRequest -Uri "https://api.versium.com/v1.0/address?campaign=BASIC&address=$A&city=Arlington&state=TX&country=US&key=b0178d5b-f0d8-48ce-9a87-1a66da31d914" -Method GET -Headers $header
    $json = Invoke-WebRequest -Uri "https://www.melissa.com/v2/lookups/personator/?melissaAddressKey=$Mak&fmt=json&id=lLqW0h1QWDvdbhZxF0rJy0**nSAcwXpxhQ0PC2lXxuDAZ-**" -Method GET -Headers $header
    $jsonobj = $json.content | ConvertFrom-Json
    $table = $jsonobj | ForEach-Object {
        [PSCustomObject] @{
            NameFull = $_.NameFull
            PhoneNumber = $_.PhoneNumber 
            AddressLine1 = $_.AddressLine1
            City = $_.City
            DemographicsGender = $_.DemographicsGender
            OwnRent = $_.OwnRent
            MaritalStatus = $_.MaritalStatus
            ChildrenAgeRange = $_.ChildrenAgeRange
            DateOfBirth = $_.DateOfBirth
            DateOfDeath = $_.DateOfDeath
        }
    }
    $table | Export-CSV $outfile –Append -NoTypeInformation
    $table | Format-Table -AutoSize
}



