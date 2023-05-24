@description('This is the azd environment name')
param name string
param location string
param containerAppEnvironmentName string
param containerRegistryName string
param appInsightsInstrumentationKey string
param imageName string

param appName string = 'orders'
param queueName string = 'myQueue'
param serviceBusNamespaceName string

var tags = { 'azd-env-name': name }

@description('These same environment variables are used by both Publisher and subscriber applications')
var pubSubAppEnvVars = [
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: appInsightsInstrumentationKey
  }
]

resource sb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: serviceBusNamespaceName
}

resource rmsak 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-10-01-preview' existing = {
  parent: sb
  name: 'RootManageSharedAccessKey'
}

@description('The Subscribing app')
module appSubscriber 'containerapp.bicep' = {
  name: 'dapr-containerapp-subscriber'
  params: {
    location: location
    containerAppEnvName: containerAppEnvironmentName
    //Using prescriptive containerAppName name notation with ref to: https://github.com/Azure/azure-dev/issues/517
    //containerAppName: '${abbrs.appContainerApps}${appName}-${resourceToken}'
    minReplicas: 0
    maxReplicas: 1
    containerAppName: '${name}${appName}'
    containerImage:  imageName
    azureContainerRegistry: containerRegistryName
    environmentVariables: pubSubAppEnvVars
    targetPort: 5001
    serviceBusQueueName: queueName
    serviceBusConnectionString: rmsak.listKeys().primaryConnectionString
    tags: union(tags, {'azd-service-name': appName})
  }
}
