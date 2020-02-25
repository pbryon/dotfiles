#!/bin/bash

script=$(basename $0)
dotnet_not_installed() {
    echo "$script: .NET Core not installed. See https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?tabs=netcore31&pivots=os-linux" >&2
    exit 1
}

cmd="dotnet"
command -v $cmd >/dev/null || dotnet_not_installed
which $cmd >/dev/null || dotnet_not_installed
$cmd --help >/dev/null || dotnet_not_installed

echo Installing FAKE CLI...
dotnet tool install -g fake-cli
echo Installing Paket...
dotnet tool install -g paket --add-source https://www.myget.org/F/paket-netcore-as-tool/api/v3/index.json
echo "--> Done"
