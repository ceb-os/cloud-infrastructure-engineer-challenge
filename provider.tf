terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" 
    }
    # provider para automatizar alta de rol para lambda 
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.26"   
    }
   } 
}


provider "aws" {
  region = var.region
  profile = "default"
}

provider "postgresql" {
  host     = aws_db_instance.nanlabs-rds.address
  port     = 5432 
  username = "postgres"
  password = random_string.rds-password.result 
  database = "postgres" 
  sslmode  = "require"
}

# tuve que agregar esto porque en cada apply queria sacar el rol, no se por que
resource "postgresql_role" "nanlabs_user" {
  name  = "nanlabs_user"
  login = true
  lifecycle {
    ignore_changes = [ roles ]
  }
}

resource "postgresql_grant_role" "grant_rds_iam" {
  role    = postgresql_role.nanlabs_user.name 
  grant_role = "rds_iam" 
} 