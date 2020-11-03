$pipelineName = "<my_pipeline_name>"

$bodyMsg = @(
     @{ Message=$pipelineName }
 )
$URL = '<my_webhook>'
$body = ConvertTo-Json -InputObject $bodyMsg
$header = @{ message = "StartedByRik"}
$response = Invoke-RestMethod -Method post -Uri $URL -Body $body -Headers $header

$response