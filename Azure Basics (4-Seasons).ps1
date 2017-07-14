###
# Create Password File & Store Credentials
### nnnnjjjjjhhhhhh
$PswdFileLocationCustomer = "C:\Users\gstaes\Demos\TenantPassword.txt" 
read-host -assecurestring | convertfrom-securestring | out-file $PswdFileLocationCustomer 
$UsernameTenant = "gunters@4-Seasons.be"
$PasswordTenant = Get-Content $PswdFileLocationCustomer | ConvertTo-SecureString
$CredentialsTenant = New-Object System.Management.Automation.PsCredential($UsernameTenant, $PasswordTenant)


###
# Login
###
Login-AzureRmAccount -Credential $CredentialsTenant 

###
# Dump Tenant Information
###
$tenant = Get-AzureRmTenant
Write-Output "Tenant Info" $tenant

###
# Dump Subscription Information
###
$subscription = get-azurermsubscription -SubscriptionName "Azure (4-Seasons)"
Write-Output "Subscription Info" $subscription

###
# Select Subscription
###
$Subscriptionid = $subscription.SubscriptionId
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionID;

###
# Get/Create ResourceGroup
###
$resourceGroupName = "Demogstaes"
$resourceGroupLocation = "West Europe"
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName 


###
# Add Recovery Services Vault for BackUp via Template
###
$templateFilePath = "C:\Users\gstaes\Demos\ExportedTemplate-RecoveryServicesBackUpVault.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;


###
# Add Network  via Template
###
$templateFilePath = "C:\Users\gstaes\Demos\ExportedTemplate-NEtwork.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;

###
# Add Azure SQL Database via Template
###
$templateFilePath = "C:\Users\gstaes\Demos\ExportedTemplate-SQLDatabase.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;

