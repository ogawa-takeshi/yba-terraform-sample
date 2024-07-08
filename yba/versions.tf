terraform {
  required_version = ">= 1.8"

  required_providers {
    yba = {
      source  = "yugabyte/yba"
      version = "~> 0.1"
    }
  }
}
