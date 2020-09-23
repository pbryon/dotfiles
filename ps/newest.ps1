function newest {
    Get-ChildItem -Exclude v* |
        Sort-Object -Property LastWriteTime -Descend |
        Select-Object -Index 0 |
}