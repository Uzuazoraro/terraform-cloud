# security group for alb, to allow acess from any where on port for http and https traffic.
# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "ext-alb-sg" {
  name        = "ext-alb-sg"
  vpc_id      = var.vpc_id
  description = "Allow TLS inbound traffic"


resource "aws_security_group_rule" "inbound-alb-http" {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    type = "ingress"
    cidr_blocks = [var.access_ip]
    security_group_id = aws_security_group.ACS["ext-alb-sg"].id
  }

resource "aws_security_group_rule" "inbound-alb-https" {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    type        = "ingress"
    cidr_blocks = [var.access_ip]
    security_group_id = aws_security_group.ACS["ext-alb-sg"].id
  }

  tags = {
    Name = "var.name"
  }
}

# security group rule for bastion to allow ssh access from your local machine
resource "aws_security_group_rule" "inbound-ssh-bastion" {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    type = "ingress"
    cidr_blocks = [var.access_ip]
    security_group_id = aws_security_group.ACS["bastion-sg"].id
  }

#security group for nginx reverse proxy, to allow access only from the external load balancer and bastion instance
resource "aws_security_group_rule" "inbound-nginx-http" {
  type                     = "ingress"
  from_port                = 443
  protocol                 = "tcp"
  to_port                  = 443
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.ACS[ext-alb-sg].id
  security_group_id        = aws_security_group.ACS[nginx-sg].id
}

# security group for bastion, to allow access into the bastion host from your IP
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  vpc_id      = var.vpc_id
  description = "Allow incoming HTTP connections"

resource "aws_security_group_rule" "inbound-bastion-ssh" {
  type                     = "ingress"
  from_port                = 22
  protocol                 = "tcp"
  to_port                  = 22
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.ACS[bastion-sg].id
  security_group_id        = aws_security_group.ACS[nginx-sg].id
}

tags = {
    Name = "var.name"
  }
}

# security group for ialb, to have acces only from nginx reverser proxy server
resource "aws_security_group" "int-alb-sg" {
  name   = "int-alb-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "var.name"
  }
}

resource "aws_security_group_rule" "inbound-ialb-https" {
  type                     = "ingress"
  from_port                = 443
  protocol                 = "tcp"
  to_port                  = 443
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.nginx-sg.id
  security_group_id        = aws_security_group.int-alb-sg.id
}

# security group for webservers, to have access only from the internal load balancer and bastion instance
resource "aws_security_group" "webserver-sg" {
  name   = "webserver-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "var.name"
  }
}

resource "aws_security_group_rule" "inbound-web-http" {
  type                     = "ingress"
  from_port                = 443
  protocol                 = "tcp"
  to_port                  = 443
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.int-alb-sg.id
  security_group_id        = aws_security_group.webserver-sg.id
}

resource "aws_security_group_rule" "inbound-web-ssh" {
  type                     = "ingress"
  from_port                = 22
  protocol                 = "tcp"
  to_port                  = 22
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.bastion-sg.id
  security_group_id        = aws_security_group.webserver-sg.id
}

# security group for datalayer to alow traffic from websever on nfs and mysql port and bastiopn host on mysql port
resource "aws_security_group" "datalayer-sg" {
  name   = "datalayer-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "var.name"
  }
}

resource "aws_security_group_rule" "inbound-nfs-port" {
  type                     = "ingress"
  from_port                = 2049
  protocol                 = "tcp"
  to_port                  = 2049
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.webserver-sg.id
  security_group_id        = aws_security_group.datalayer-sg.id
}

resource "aws_security_group_rule" "inbound-mysql-bastion" {
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  to_port                  = 3306
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.bastion-sg.id
  security_group_id        = aws_security_group.datalayer-sg.id
}

resource "aws_security_group_rule" "inbound-mysql-webserver" {
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  to_port                  = 3306
  cidr_blocks = [var.access_ip]
  source_security_group_id = aws_security_group.webserver-sg.id
  security_group_id        = aws_security_group.datalayer-sg.id
}