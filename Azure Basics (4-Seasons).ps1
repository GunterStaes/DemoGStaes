###
# Create Password File & Store Credentials
### 
$PswdFileLocationCustomer = "C:\Users\gstaes\Source\Repos\DemoGStaes\TenantPassword.txt" 
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
$templateFilePath = "C:\Users\gstaes\Source\Repos\DemoGStaes\ExportedTemplate-RecoveryServicesBackUpVault.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;

###
# Add Network  via Template
###
$templateFilePath = "C:\Users\gstaes\Source\Repos\DemoGStaes\ExportedTemplate-NEtwork.json"
$#templateFilePath = "https://github.com/GunterStaes/DemoGStaes/blob/master/ExportedTemplate-Network.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;

###
# Add VM via Template
###
$templateFilePath = "C:\Users\gstaes\Source\Repos\DemoGStaes\ExportedTemplate-vm.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;


