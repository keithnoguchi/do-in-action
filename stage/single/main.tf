terraform {
  backend "s3" {
    bucket  = "github-keinohguchi-doform-state"
    key     = "stage/single/terraform.tfstate"
    region  = "us-west-1"
    encrypt = true
  }
}

# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_TOKEN}"
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "web" {
  image              = "ubuntu-16-04-x64"
  name               = "web-1"
  region             = "nyc3"
  size               = "512mb"
  ipv6               = true
  private_networking = true
  ssh_keys           = ["${var.DO_FINGERPRINT}"]
}
