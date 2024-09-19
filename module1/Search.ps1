write-host "Enter the path you want to search"
$path = read-host
Get-ChildItem $Path "*.yml" -Recurse