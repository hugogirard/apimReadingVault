param apimName string

resource apiManagement 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-09-01-preview' = {
  parent: apiManagement
  name: 'validatevaultsecret'    
  properties: {
    displayName: 'Validate Vault Secret'
    apiRevision: '1'
    path: 'vault'
    protocols: [
      'https'
    ]
    subscriptionRequired: false
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
    displayName: 'validate'
    method: 'POST'
    urlTemplate: '/'
    description: 'Validate secret from the vault'    
  }
}

resource policyOperation 'Microsoft.ApiManagement/service/apis/operations/policies@2022-09-01-preview' = {  
  parent: operationPost
  name: 'policy'  
  properties: {
    format: 'rawxml'
    value: loadTextContent('./policy.xml')
  }
}
