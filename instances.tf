# Create EC2 (Bastion) in Public Subnet with Security Group from Step 7
resource "aws_instance" "bastion" {
  ami             = "ami-04b70fa74e45c3917" 
  instance_type  = var.machine_type
  subnet_id  = module.network.subnets-AZ1["public_subnet1"].id
  associate_public_ip_address = true
  vpc_security_group_ids  =  [aws_security_group.ssh_from_anywhere.id]
  key_name  = aws_key_pair.tf-key-pair.id
    tags = {
    Name = "Bastion"
  }


  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.rsa-key.private_key_pem}' > /home/ubuntu/tf-key-pair.pem", 
      "chmod 400 /home/ubuntu/tf-key-pair.pem" 
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  
      private_key = tls_private_key.rsa-key.private_key_pem
      host        = self.public_ip  
    }
  }

  depends_on = [aws_instance.bastion]  

  provisioner "local-exec"{
    command= "echo ${self.public_ip} > inventory"
  }
}


# Create EC2 (Application) in Private Subnet with Security Group from Step 8
resource "aws_instance" "application" {
  ami           = "ami-04b70fa74e45c3917" 
  instance_type = var.machine_type
  subnet_id  = module.network.subnets-AZ1["private_subnet1"].id
#   instance_type = "t2.micro" 
#   subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids  =  [aws_security_group.ssh_and_port_3000_from_vpc_cidr.id]
  key_name      = aws_key_pair.tf-key-pair.id
    tags = {
    Name = "Application"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo '${tls_private_key.rsa-key.private_key_pem}' > private_key.pem
    chmod 400 private_key.pem
  EOF
}

