resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_tag_name
  }
}



resource "aws_security_group" "load_balancer_security_group" {
  name        = var.load_balancer_security_group_name
  vpc_id      = aws_vpc.app_vpc.id
  description = "load balancer security group"
  ingress = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow HTTP traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow HTTP traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow HTTP traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_security_group" "ecs_security_group" {
  name        = var.ecs_security_group_name
  vpc_id      = aws_vpc.app_vpc.id
  description = "ecs service security group"
  ingress = [
    {
      from_port        = 1337
      to_port          = 1337
      protocol         = "tcp"
      cidr_blocks      = []
      security_groups  = ["${aws_security_group.load_balancer_security_group.id}"]
      description      = "Allow HTTP traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow HTTP traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

}


resource "aws_security_group" "rds_security_group" {
  name        = var.rds_security_group_name
  description = "Allow access to PostgresSQL from ECS tasks"
  vpc_id      = aws_vpc.app_vpc.id

  ingress = [
    {
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      cidr_blocks      = []
      security_groups  = ["${aws_security_group.ecs_security_group.id}"]
      description      = "Allow ecs to connect"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow Postgres network"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = local.availability_zones[0]
  map_public_ip_on_launch = false
}
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = local.availability_zones[1]
  map_public_ip_on_launch = false
}
resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.1.3.0/24"
  availability_zone       = local.availability_zones[2]
  map_public_ip_on_launch = false
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = var.igw_tag_name
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association_subnet_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_subnet_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_subnet_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.route_table.id
}





output "ecs_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}
output "alb_security_group_id" {
  value = aws_security_group.load_balancer_security_group.id
}
output "rds_security_group_id" {
  value = aws_security_group.rds_security_group.id
}

output "aws_vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}
output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}
output "subnet_c_id" {
  value = aws_subnet.subnet_c.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}