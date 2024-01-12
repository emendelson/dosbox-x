param(
[string]$fn
)
Start-Process -FilePath $fn -Verb Print -PassThru | %{sleep 10;$_} | kill

exit