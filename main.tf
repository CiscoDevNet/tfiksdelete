#get the data fro the global vars WS
data "terraform_remote_state" "global" {
  backend = "remote"
  config = {
    organization = "CiscoDevNet"
    workspaces = {
      name = var.globalwsname
    }
  }
}


# Intersight Provider Information 
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.11"
    }
  }
}

variable "name" {
  default = "https://www.intersight.com"
}

variable "globalwsname" {
  type = string
}

variable "api_key" {
  type = string
}

variable "secretkey" {
  type = string
}

variable "api_endpoint" {
  default = "https://www.intersight.com"
}

variable "organization_name" {
  default = "default"
}

provider "intersight" {
  apikey        = var.api_key
  secretkey = var.secretkey
  endpoint      = var.api_endpoint
}

data "intersight_organization_organization" "organization_moid" {
  name = var.organization_name
}

resource "intersight_kubernetes_cluster_profile" "kubeprofaction" {
  action = "Delete"
  name = local.clustername 
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization_moid.results.0.moid 
  }
}

locals {
  clustername = yamldecode(data.terraform_remote_state.global.outputs.clustername)
}
