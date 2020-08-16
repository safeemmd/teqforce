data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "jen_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id

}
