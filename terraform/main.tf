# 1. VPC
resource "aws_vpc" "unify_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = var.tags_padrao
}

# 2. Sub-rede Pública
resource "aws_subnet" "unify_subnet_publica" {
  vpc_id                  = aws_vpc.unify_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags                    = var.tags_padrao
}

# 3. Internet Gateway
resource "aws_internet_gateway" "unify_igw" {
  vpc_id = aws_vpc.unify_vpc.id
  tags   = var.tags_padrao
}

# 4. Route Table
resource "aws_route_table" "unify_rt" {
  vpc_id = aws_vpc.unify_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.unify_igw.id
  }
  tags = var.tags_padrao
}

# Associação da Route Table com a Sub-rede
resource "aws_route_table_association" "unify_rta" {
  subnet_id      = aws_subnet.unify_subnet_publica.id
  route_table_id = aws_route_table.unify_rt.id
}

# 5. Security Group
resource "aws_security_group" "unify_sg" {
  name        = "unify_sg"
  description = "Permitir SSH e trafego para a API na porta 3000"
  vpc_id      = aws_vpc.unify_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Unify Node.js"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags_padrao
}

# 6. Par de Chaves SSH
resource "aws_key_pair" "unify_keypair" {
  key_name   = "unify_deploy_key"
  public_key = file("${path.module}/../unify_key.pub") # Aponta para a chave gerada no Passo 1
  tags       = var.tags_padrao
}

# 7. Instância EC2 (Ubuntu 22.04 LTS)
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "unify_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.unify_subnet_publica.id
  vpc_security_group_ids = [aws_security_group.unify_sg.id]
  key_name               = aws_key_pair.unify_keypair.key_name

  tags = var.tags_padrao
}