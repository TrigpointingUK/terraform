variable "project" {
  description = "The default project"
  default     = "trigpointinguk"
}

variable "region" {
  description = "The region to use"
  default     = "europe-west1"
}

variable "zone" {
  description = "The zone to use"
  default     = "europe-west1-a"
}

variable "multiregion" {
  description = "The region to use for multiregional buckets"
  default     = "eu"
}

variable "multi_region" {
  description = "The region to use for multiregional keyrings etc"
  default     = "europe"
}

variable "tuk" {
  description = "Use to ensure projects,buckets etc have different names in test"
  default     = "tuk"
}

variable "terraform_impersonators" {
  description = "A list of users permitted to impersonate the terraform account"
  default     = ["user:teasel.ian@gmail.com"]
}
