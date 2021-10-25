# Azure Terraform PoC

[![MIT Licensed](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](./LICENSE)
[![Powered by Modus_Create](https://img.shields.io/badge/powered_by-Modus_Create-blue.svg?longCache=true&style=flat&logo=data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMzIwIDMwMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cGF0aCBkPSJNOTguODI0IDE0OS40OThjMCAxMi41Ny0yLjM1NiAyNC41ODItNi42MzcgMzUuNjM3LTQ5LjEtMjQuODEtODIuNzc1LTc1LjY5Mi04Mi43NzUtMTM0LjQ2IDAtMTcuNzgyIDMuMDkxLTM0LjgzOCA4Ljc0OS01MC42NzVhMTQ5LjUzNSAxNDkuNTM1IDAgMCAxIDQxLjEyNCAxMS4wNDYgMTA3Ljg3NyAxMDcuODc3IDAgMCAwLTcuNTIgMzkuNjI4YzAgMzYuODQyIDE4LjQyMyA2OS4zNiA0Ni41NDQgODguOTAzLjMyNiAzLjI2NS41MTUgNi41Ny41MTUgOS45MjF6TTY3LjgyIDE1LjAxOGM0OS4xIDI0LjgxMSA4Mi43NjggNzUuNzExIDgyLjc2OCAxMzQuNDggMCA4My4xNjgtNjcuNDIgMTUwLjU4OC0xNTAuNTg4IDE1MC41ODh2LTQyLjM1M2M1OS43NzggMCAxMDguMjM1LTQ4LjQ1OSAxMDguMjM1LTEwOC4yMzUgMC0zNi44NS0xOC40My02OS4zOC00Ni41NjItODguOTI3YTk5Ljk0OSA5OS45NDkgMCAwIDEtLjQ5Ny05Ljg5NyA5OC41MTIgOTguNTEyIDAgMCAxIDYuNjQ0LTM1LjY1NnptMTU1LjI5MiAxODIuNzE4YzE3LjczNyAzNS41NTggNTQuNDUgNTkuOTk3IDk2Ljg4OCA1OS45OTd2NDIuMzUzYy02MS45NTUgMC0xMTUuMTYyLTM3LjQyLTEzOC4yOC05MC44ODZhMTU4LjgxMSAxNTguODExIDAgMCAwIDQxLjM5Mi0xMS40NjR6bS0xMC4yNi02My41ODlhOTguMjMyIDk4LjIzMiAwIDAgMS00My40MjggMTQuODg5QzE2OS42NTQgNzIuMjI0IDIyNy4zOSA4Ljk1IDMwMS44NDUuMDAzYzQuNzAxIDEzLjE1MiA3LjU5MyAyNy4xNiA4LjQ1IDQxLjcxNC01MC4xMzMgNC40Ni05MC40MzMgNDMuMDgtOTcuNDQzIDkyLjQzem01NC4yNzgtNjguMTA1YzEyLjc5NC04LjEyNyAyNy41NjctMTMuNDA3IDQzLjQ1Mi0xNC45MTEtLjI0NyA4Mi45NTctNjcuNTY3IDE1MC4xMzItMTUwLjU4MiAxNTAuMTMyLTIuODQ2IDAtNS42NzMtLjA4OC04LjQ4LS4yNDNhMTU5LjM3OCAxNTkuMzc4IDAgMCAwIDguMTk4LTQyLjExOGMuMDk0IDAgLjE4Ny4wMDguMjgyLjAwOCA1NC41NTcgMCA5OS42NjUtNDAuMzczIDEwNy4xMy05Mi44Njh6IiBmaWxsPSIjRkZGIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiLz4KPC9zdmc+)](https://moduscreate.com)

-   [Objective](#Objective)
-   [Architecture-chart](#Architecture-chart)
-   [Tutorial](#Tutorial)
-   [Modus Create](#modus-create)
-   [Licensing](#licensing)

## Objective - Deploy Docker Swarm on Azure

This is a PoC showing how to spin up Docker Swarm at Azure. 
This is a basic example and improvements should be done for production environments like using WAF, Key Vault, TLS, etc...

-   3 Docker Swarm managers (will also be a worker node) - Availability set
-   2 Docker Swarm worker nodes - Scale set
-   A Bastion Host to access the Docker Swarm inside the VPC
-   Storage Share to share files between the nodes

## Architecture chart
![Architecture Chart](https://github.com/ModusCreateOrg/azure-terraform-demos/blob/main/azure_poc_02/images/architecture.png?raw=true)

## Software versions used in this PoC

-   [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) (made with Azure CLI `2.28.0`)
-   HashiCorp [Terraform](https://terraform.io/downloads.html) (made with Terraform version: `1.0.9`)
-   [Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html) (azurerm version: `2.82.0`)

## Tutorial

### Login to a subscription & run terraform
```bash
az login

# At \terraform\deployments\demo do:
terraform plan 
terraform apply
```
You will have all services up and running.

### Check your Docker Swarm nodes
Using the Bastion Host you can check the cluster nodes:

![Bastion Host login](https://github.com/ModusCreateOrg/azure-terraform-demos/blob/main/azure_poc_02/images/login_bastion.png?raw=true)

Username=ubuntu, Password=This~is#a!P0C (Note: This is a PoC. Secrets should be stored at KeyVault in prod environments)

Just access the Bastion Host and send the following command:
```bash
docker node ls
```

![Docker Swarm nodes](https://github.com/ModusCreateOrg/azure-terraform-demos/blob/main/azure_poc_02/images/cluster_nodes.png?raw=true)


### Create a docker service and test it
Using the Bastion Host send the following command:

```bash
docker service create --name nginx --publish 80:80 nginx
```

In a few secconds you will have NGINX up and running in your Docker Swarm cluster. 
Just access your Public IP address (poc2-pip-01-us-dev - running at port 80): http://xxx.xxx.xxx.xx

![Docker Swarm NGINX](https://github.com/ModusCreateOrg/azure-terraform-demos/blob/main/azure_poc_02/images/nginx.png?raw=true)


## Modus Create

[Modus Create](https://moduscreate.com) is a digital product consultancy. We use a distributed team of the best talent in the world to offer a full suite of digital product design-build services; ranging from consumer facing apps, to digital migration, to agile development training, and business transformation.

<a href="https://moduscreate.com/?utm_source=labs&utm_medium=github&utm_campaign=Azure_Terraform_PoC"><img src="https://res.cloudinary.com/modus-labs/image/upload/h_80/v1533109874/modus/logo-long-black.svg" height="80" alt="Modus Create"/></a>
<br />

This project is part of [Modus Labs](https://labs.moduscreate.com/?utm_source=labs&utm_medium=github&utm_campaign=Azure_Terraform_PoC).

<a href="https://labs.moduscreate.com/?utm_source=labs&utm_medium=github&utm_campaign=Azure_Terraform_PoC"><img src="https://res.cloudinary.com/modus-labs/image/upload/h_80/v1531492623/labs/logo-black.svg" height="80" alt="Modus Labs"/></a>

## Licensing

This project is [MIT licensed](./LICENSE).

