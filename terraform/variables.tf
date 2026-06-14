variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "O tipo de instância EC2 (Free Tier)"
  type        = string
  default     = "t2.micro"
}

variable "tags_padrao" {
  description = "Tags obrigatórias para todos os recursos"
  type        = map(string)
  default     = {
    Name    = "Unify-API-Server"
    Projeto = "Trabalho Final Cloud"
    Aluno   = "Lucas Weigel"
    Turma   = "T28"
  }
}