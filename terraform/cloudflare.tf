terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_r2_bucket" "images_bucket" {
  account_id = var.cloudflare_account_id
  name       = "imagehub-bucket"
  location   = "WEUR"
}