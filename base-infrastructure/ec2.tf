
# EC2 Instance
resource "aws_instance" "cyd_ec2" {
  ami                    = data.aws_ami.ubuntu_20_04.id
  instance_type          = var.instance_type
  key_name               = "cyd-key"
  vpc_security_group_ids = [aws_security_group.cyd_ec2.id]
  subnet_id              = aws_subnet.public_1.id
  
  tags = {
    Name = "cyd_ec2-instance"
  }
}