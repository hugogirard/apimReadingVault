targetScope='subscription'

@description('The location to deploy the resources')
@allowed([
  'canadacentral'
  'canadaeast'
])
param location string
@description('The name of the resource group')
param resourceGroupName string

@description('The organization name for APIM')
@secure()
param organizationName string

@description('The email of the administrator of APIM')
@secure()
param administratorEmail string


var suffix = uniqueString(rg.id)

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module apim 'modules/apim/apim.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'apim'
  params: {
    administratorEmail: administratorEmail
    location: location
    organizationName: organizationName
    suffix: suffix
  }
}

module kv 'modules/keyVault/keyVault.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'keyvault'
  params: {
    identityId: apim.outputs.identityId
    location: location
    suffix: suffix
  }
}

module apis 'modules/apis/validateSecretVault.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'apis'
  params: {
    apimName: apim.outputs.apimName
  }
}
