variable "base_domain" {
  type    = string
  default = "amber.vision"
}

variable "keybase_txt_record" {
  type      = string
  sensitive = true
}
