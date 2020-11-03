# ADF Pipeline OnDemand Invoke
Invoke an Azure Data Factory pipeline through a Azure Automation Runbook Webhook to make it runnable on-demand from any application able to perform POST calls.

## Prerequisites 
- PowerShell v7.x
- PowerShell Az Module
- PowerShell AzDataFactory Module
- Azure Subscription
- Azure Data Factory pipeline to run

## adf_pipeline_invoke.ps1
Runs ADF pipeline using PowerShell AzDataFactory module checking periodically run status, printing information for the user.

## adf_pipeline_invoke_runbook.ps1
Runs ADF pipeline using PowerShell AzDataFactory module checking periodically run status, printing information for the user in a Azure Automation Runbook getting 
credenatials to access ADF, SubscriptionID, Resource Group and ADF's name from Automation assets.
Pipeline name is passed as a parameter.

## adf_pipeline_invoke_webhook_call.ps1
Example written in PowerShell to call an Azure Automation Runbook through a Webhook in order to execute an ADF's pipeline passing its name in the body message.