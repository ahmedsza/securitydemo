STORAGE_ACCOUNT_NAME="${DNS_PREFIX}terraform"
CONTAINER_NAME="tsstate"

# Create storage account
az storage account create --resource-group $AZURE_RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --location $AZURE_RESOURCE_GROUP_LOCATION

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $AZURE_RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "::set-output name=account_name::$STORAGE_ACCOUNT_NAME"
echo "::set-output name=container_name::$CONTAINER_NAME"