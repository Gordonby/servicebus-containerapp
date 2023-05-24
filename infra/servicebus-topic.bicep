@description('Name of the Service Bus namespace')
param serviceBusNamespaceName string

@description('Name of the Topic')
param serviceBusTopicName string

@description('Location for all resources.')
param location string = resourceGroup().location

var servicebusName = 'sb-${serviceBusNamespaceName}-${uniqueString(resourceGroup().id, serviceBusNamespaceName)}'
resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: servicebusName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  parent: serviceBusNamespace
  name: serviceBusTopicName
  properties: {
    
  }
}

output serviceBusNamespace string =  serviceBusNamespace.name
output serviceBusFqdn string = '${serviceBusNamespace.name}.servicebus.windows.net'
output serviceBusQueueName string = serviceBusTopic.name
