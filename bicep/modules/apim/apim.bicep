param location string
param suffix string
param organizationName string
param administratorEmail string

resource apiManagement 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: 'api-int-${suffix}'
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: administratorEmail
    publisherName: organizationName                  
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output apimName string = apiManagement.name
output identityId string = apiManagement.identity.principalId
