param apimName string
param vaultName string

resource apim 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apimName
}

resource vaultValue 'Microsoft.ApiManagement/service/namedValues@2022-09-01-preview' = {
  parent: apim
  name: 'keyVaultName'
  properties: {
    displayName: 'KeyVaultName'
    value: vaultName
    secret: true
  }
}
