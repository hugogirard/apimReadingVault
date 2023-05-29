param apimName string

resource apiManagement 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-09-01-preview' = {
  parent: apiManagement
  name: 'vault-api'  
  properties: {
    path: 'vault'
    protocols: [
      'https'
    ]
    subscriptionRequired: true
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    isCurrent: true
  }
}

resource operationPost 'Microsoft.ApiManagement/service/apis/operations@2022-09-01-preview' = {
  parent: api
  name: 'validate'
  properties: {
    displayName: 'Validate'
    method: 'POST'
    urlTemplate: '/'
    description: 'Validate a secret'
  }
}
