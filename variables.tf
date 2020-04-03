variable "vpcName" {
        default = "Bikram-TF"
}
variable "region" {
     default = "us-east-1"
}
variable "availabilityZoneA" {
     default = "us-east-1a"
}
variable "availabilityZoneB" {
     default = "us-east-1b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.15.0.0/24"
}
variable "publicsubnetzoneACIDRblock" {
    default = "10.15.0.0/26"
}
variable "privatesubnetzoneACIDRblock" {
    default = "10.15.0.64/26"
}
variable "publicsubnetzoneBCIDRblock" {
    default = "10.15.0.128/26"
}
variable "privatesubnetzoneBCIDRblock" {
    default = "10.15.0.192/26"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
# end of variables.tf
