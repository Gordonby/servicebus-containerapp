param location string
param principalId string = ''
param nameseed string
param tags object
param pubsubQueueName string = 'myQueue'

@description('The container registry is used by azd to store your images')
module registry 'containerregistry.bicep' = {
  name: 'container-registry-resources'
  params: {
    location: location
    tags: tags
    nameseed: nameseed
  }
}

@description('The container apps environment is where the applications will be deployed to')
module containerAppsEnv 'containerapps-env.bicep' = {
  name: 'caenv-resources'
  params: {
    location: location
    nameseed: nameseed
    tags: tags
  }
}

// module servicebusTopic 'servicebus-topic.bicep' = {
//   name: 'servicebus-topic-resources'
//   params: {
//     serviceBusNamespaceName: nameseed
//     serviceBusTopicName: pubsubTopicName
//     location: location
//   }
// }

module servicebusQueue 'servicebus-queue.bicep' = {
  name: 'servicebus-queue-resources'
  params: {
    serviceBusNamespaceName: nameseed
    serviceBusQueueName: pubsubQueueName
    location: location
  }
}

output AZURE_COSMOS_CONNECTION_STRING_KEY string = 'AZURE-COSMOS-CONNECTION-STRING'
output APPINSIGHTS_INSTRUMENTATIONKEY string = containerAppsEnv.outputs.appInsightsInstrumentationKey
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.AZURE_CONTAINER_REGISTRY_ENDPOINT
output AZURE_CONTAINER_REGISTRY_NAME string = registry.outputs.AZURE_CONTAINER_REGISTRY_NAME
output AZURE_CONTAINERAPPS_ENVIRONMENT_NAME string = containerAppsEnv.outputs.containerAppEnvironmentName
