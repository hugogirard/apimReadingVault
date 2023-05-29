param location string
param suffix string
param identityId string

var tenantId = subscription().tenantId
var contosoPassword = base64('contoso1234!')

var roleIdMapping = {
  'Key Vault Administrator': '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  'Key Vault Certificates Officer': 'a4417e6f-fecd-4de8-b567-7b0420556985'
  'Key Vault Crypto Officer': '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
  'Key Vault Crypto Service Encryption User': 'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  'Key Vault Crypto User': '12338af0-0e69-4776-bea7-57ae8d297424'
  'Key Vault Reader': '21090545-7ca7-4776-b22c-e363652d74d2'
  'Key Vault Secrets Officer': 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  'Key Vault Secrets User': '4633458b-17de-408a-b874-0445c86b69e6'
}
var roleName = 'Key Vault Secrets Officer'

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kvi${suffix}'
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
    enableSoftDelete: false
    networkAcls: {
      defaultAction: 'Allow'      
      bypass: 'AzureServices'
    }
  }
}

resource contosoUser 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'contoso'
  parent: kv
  properties: {
    value: contosoPassword
  }
}

resource kvRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(roleIdMapping[roleName],identityId,kv.id)
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIdMapping[roleName])
    principalId: identityId
    principalType: 'ServicePrincipal'
  }
}
