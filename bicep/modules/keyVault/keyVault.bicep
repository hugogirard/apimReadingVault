param location string
param suffix string
param identityId string

var tenantId = subscription().tenantId
var contosoPassword = base64('contoso1234!')

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv${suffix}'
  location: location
  properties: {
    tenantId: tenantId
    accessPolicies: [
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    enableRbacAuthorization: true
    networkAcls: {
      defaultAction: 'Allow'      
      bypass: 'AzureServices'
    }
  }
}

resource contosoUser 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'contoso@contoso.com'
  parent: kv
  properties: {
    value: contosoPassword
  }
}
