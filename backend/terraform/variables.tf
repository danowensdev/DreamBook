variable "worker_image_tag" {
  type = string
}
variable "worker_image_uri" {
  type = string
}


// Allows starting interactive shell in the worker container
variable "activate_tty" {
  type = bool
  default = true 
}