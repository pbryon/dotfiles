function tail {
    Get-Content @args -Wait -Tail 1
}