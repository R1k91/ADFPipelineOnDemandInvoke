#setup variables
$SubscriptionID = '<my_subscription_id>' 
$ResourceGroupName = '<my_resource_group_name'
$DataFactoryName = '<my_adf_name>' 
$PipelineName = '<my_pipeline_name>'

$CheckLoopTime = 5

try {
    #Connect to Azure and set working subscription
    Connect-AzAccount
    Set-AzContext -SubscriptionId $SubscriptionID | Out-Null

     #Get data factory object
     $df = Get-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $DataFactoryName

     #If exists - run it
    If($df) {
        Write-Output "Connected to data factory $DataFactoryName on $ResourceGroupName as $($AzureDataFactoryUser.UserName)"
        Write-Output "Running pipeline: $PipelineName"

        $RunID = Invoke-AzDataFactoryV2Pipeline -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -PipelineName $PipelineName
        $RunInfo = Get-AzDataFactoryV2PipelineRun -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -PipelineRunId $RunID

        Write-Output "`nPipeline triggered!"
        Write-Output "RunID: $($RunInfo.RunId)"
        Write-Output "Started: $($RunInfo.RunStart)`n"

        $sw =  [system.diagnostics.stopwatch]::StartNew()
        While (($Pipeline = Get-AzDataFactoryV2PipelineRun -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -PipelineRunId $RunID | Select-Object -ExpandProperty "Status") -eq "InProgress")
        {
            #Write-Output 
            $RunInfo = Get-AzDataFactoryV2PipelineRun -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -PipelineRunId $RunID
            Write-Output "`rLast status: $($RunInfo.Status) | Last updated: $($RunInfo.LastUpdated) | Running time: $($sw.Elapsed.ToString('dd\.hh\:mm\:ss'))"
            Start-Sleep $CheckLoopTime
        }
        $sw.Stop()

        $RunInfo = Get-AzDataFactoryV2PipelineRun -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -PipelineRunId $RunID

        Write-Output "`nFinished running in $($sw.Elapsed.ToString('dd\.hh\:mm\:ss'))!"
        Write-Output "Status:"
        Write-Output $RunInfo.Status

        if ($RunInfo.Status -ne "Succeeded"){                    
             throw "There was an error with running pipeline: $($RunInfo.PipelineName). Returned message was:`n$($RunInfo.Message)"
        }
    }
}
catch {
    Throw
}