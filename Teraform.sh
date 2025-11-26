 terraform init
terraform plan
terraform apply -auto-approve  ## app not yess
terraform validate ## verify simtace
terraform show

terraform output
terraform output pet-name

terraform plan --refresh=false

##HashiCorp Configuration Language
main.tf
resource "aws_instance" "webserver" {
  ami  = "ami-0edab43"
  instance_type = "t2.micro"
}


# Terraform State
terraform.tfstate
#### GETTING STARTED WITH 
1. Install terraform
wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_limux_amd64.zip
unzip terraform_0.13.0_limux_amd64.zip
mv terraform /usr/local/bin
terraform version

aws.tf
resource "aws_instance" "webserver" {
  ami  = "ami-0edab43"
  instance_type = "t2.micro"
}
------------------
2. HashiCorp Configuration language (HCL) Basics

<block> <parameters> {
    key1 = value1
    key2 = value2
}

mkdir /root/terraform-local-file
cd /root/terraform-local-file

local.tf
resource "local_file" "pet" {
  filename  = "/root/pets.txt"
  content = "We love pets!"
}

aws_s3.tf
resource "aws_s3_bucket" "data" {
  bucket  = "webserver-bucket-org-2207"
  acl = "private"
}
### Step start with terraform

1. create file
2. run the Terraform Init command
terraform init
3. Review the execution plan using the terraform plan command
terraform plan
4. Apply the changes ussing the Terraform Apply command
terraform apply

terraform show  ## see detail the resources just created

### Update and Destroy infrastructure
local.tf
resource "local_file" "pet" {
  filename  = "/root/pets.txt"
  content = "We love pets!"
  file_permission = "0700"
}

terraform plan
terraform apply
ls -ltr /root/pets.txt

terraform destroy ## delete all resources

## don't the content show up in the execution plan at all
cat main.tf 
resource "local_sensitive_file" "games" {
  filename     = "/root/favorite-games"
  content  = "FIFA 21"
}
=====================================
## Terraform Basics
# Using Terraform Providers
Have 3 providers:
1 Pfficial: AWS AZU, 
2. Partner
3. Community

terraform init # will download plugins for provider and lot of download
The plugins are download into a hidden directory
ls /root/terraform-local-file/.terraform/plugins

# Cpmfiguration Directory
ls /root/terraform-local-file

local.tf
resource "local_file" "pet" {
  filename  = "/root/pets.txt"
  content = "We love pets!"
}
cat.tf
resource "local_file" "cat" {
  filename  = "/root/cat.txt"
  content = "My favorite pet is Ms.nguyen!"
}

main.tf
resource "local_file" "pet" {
  filename  = "/root/pets.txt"
  content = "We love pets!"
}
cat.tf
resource "local_file" "cat" {
  filename  = "/root/cat.txt"
  content = "My favorite pet is Ms.nguyen!"
}
##
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.13.3"
    }
  }
}

## Multiple Providers
main.tf
resource "local_file" "pet" {
  filename  = "/root/pets.txt"
  content = "We love pets!"
}
resource "random_pet" "my-pet" {
  prefix  = "Mrs"
  separator = "."
  length = "1"
}
#############
vi cloud-provider.tf
resource "aws_instance" "ec2_instance" {
          ami       =  "ami-0eda277a0b884c5ab"
          instance_type = "t2.large"
}


resource "aws_ebs_volume" "ec2_volume" {
          availability_zone = "eu-west-1"
          size  =    10
}

vi kube.tf
resource "local_file" "data" {
        filename = "/root/k8s.txt"
        content = "kubernetes the hard way!"
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "development"
  }
}
### Using input variables
Argument   Value
filename   "/root/pets.txt"
content    "We love pets"
prefix     "Mrs"
separator  "."
length     "1"

main.tf
resource "local_file" "pet" {
        filename = var.filename
        content = var.content
}
resource "random_pet" "my-pet" {
        prefix = var.prefix
        separator = var.separator
        lenghth = var.length
}


variables.tf
variable "filename" {
  default = "/root/pets.txt"
}
variable "content" {
  default = "We love pets!"
}
variable "prefix" {
  default = "Mrs"
}
variable "separator" {
  default = "."
}
variable "length" {
  default = "1"
}
-----------------
main.tf
resource "aws_instance" "webserver" {
        ami = var.ami
        instance_type = var.instance_type
}
variables.tf
variable "ami" { 
  default = "ami-0edab43b6"
}
variable "instance_type" {
  default = "t2.micro"
}
## Understanding the variable Block

variables.tf
variable "filename" {
  default = "/root/pets.txt"
  type = string
  description = "the path of local file"
}
variable "content" {
  default = "We love pets!"
  type = string
  description = "the path of local file"
}
variable "prefix" {
  default = "Mrs"
  type = string
  description = "the path of local file"
}
variable "separator" {
  default = "."
}
variable "length" {
  default = "1"
}
---------------------------
variables.tf
variable "length" {
  default = "2"
  description = "length of the pet name"
}
variable "password_change" {
  default = true
  type = bool
}
#List
variables.tf
variable "prefix" {
  default = [ "Mr", "Mrs", "Sir" ]
  type = list 
}

main.tf
resource "random_pet" "my-pet" {
  prefix = var.prefix[0]
}
#Map
variables.tf
variable file-content {
  type = map
  defaul = {
    "statement1" = "We love pets!"
    "statement2" = "We love animals!"
  } 
}

main.tf
resource local_file my-pet {
  filename = "/root/pets.txt"
  content = var.file-content["statement2"]
}
# List of a Type
variables.tf
variable "bella" {
  type = object({
    name = string
    color = string
    age = number
    food = list(string)
    favorite_pet = bool
  })
  defaul = {
    name = "bella"
    color = "brown"
    age = 7
    food = ["fish", "chicken", "turkey"]
    favorite_pet = true
  }
}

variables.tf
variable kitty {
  type = tuple([string, number, bool])
  defaul = ["cat", 7, true]
}
------------------------------------------
## Using variables in terraform
main.tf
resource "local_file" "pet" {
        filename = var.filename
        content = var.content
}
resource "random_pet" "my-pet" {
        prefix = var.prefix
        separator = var.separator
        lenghth = var.length
}


variables.tf
variable "filename" {
#  default = "/root/pets.txt"
}
variable "content" {
#  default = "We love pets!"
}
variable "prefix" {
#  default = "Mrs"
}
variable "separator" {
#  default = "."
}
variable "length" {
#  default = "1"
}

terraform apply -var "filename=/root/pets.txt" -var "content=We love pets!" -var "prefix=Mrs" -var "separator=." -var "length=2"
#Environment Variables
export TF_VAR_filename="/root/pets.txt"
export TF_VAR_content="We love pets!"
export TF_VAR_prefix="Mrs"
export TF_VAR_separator="."
export TF_VAR_length="2"
terraform apply

#Variable Definition files
terraform.tfvars  # or .rfvars.json
filename="/root/pets.txt"
content="We love pets!"
prefix="Mrs"
separator="."
length="2"

terraform apply -var-file variables.tfvars
#
main.tf
resource "local_file" "pet" {
        filename = var.filename
}

variables.tf
variable filename {
  type = string
}

export TF_VAR_filename="/root/cats.txt"

terraform.tfvars 
filename = "/root/pets.txt"

variable.auto.tfvars 
filename = "/root/mypet.txt"

terraform apply -var "filename=/root/best-pet.txt"
#so 
oder    option
1       env variables
2       terraform.tfvars
3.      *.auto.tfvars
4.      -var or -var-file
----------------------------------------------
## Resource Attributes
main.tf
resource "local_file" "pet" {
        filename = var.filename
        content = "My favorite pet is ${random_pet.my-pet.id}"
}
resource "random_pet" "my-pet" {
        prefix = var.prefix
        separator = var.separator
        lenghth = var.length
}
------------------
cat main.tf 
resource "local_file" "time" {
  filename = "/root/time.txt"
  content = "Time stamp of this file is ${time_static.time_update.id}"
}
resource "time_static" "time_update" {
}
cat /root/time.txt 
Time stamp of this file is 2025-08-04T09:30:55Z
terraform show
-------------
# Resource Dêpendencies
main.tf
resource "local_file" "pet" {
        filename = var.filename
        content = "My favorite pet is Mr.Cat"
        depends_on = [
            random_pet.my-pet 
        ]
}
resource "random_pet" "my-pet" {
        prefix = var.prefix
        separator = var.separator
        lenghth = var.length
}
---------------------------
cat key.tf 
resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

terraform init
terraform apply
terraform show

cat key.tf 
resource "local_file" "key_details" {
  filename = "/root/key.txt"
  content = tls_private_key.pvtkey.private_key_pem
}
  
resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
terraform init
terraform apply
terraform show
cat /root/key.txt

terraform destroy

cat main.tf 
resource "local_file"  "whale" {
  filename = "/root/whale"
  content = "whale"
  depends_on = [local_file.krill]
}
resource "local_file" "krill"  {
  filename = "/root/krill"
  content  = "krill"
}
-------------------------
## Output Variables
main.tf
resource "local_file" "pet" {
        filename = var.filename
        content = "My favorite pet is ${random_pet.my-pet.id}"
}
resource "random_pet" "my-pet" {
        prefix = var.prefix
        separator = var.separator
        lenghth = var.length
}
output "pet-name" {
  value  = random_pet.my-pet.id
  description = "Record the value of pet ID generated by the random_pet resource"
}

terraform output
terraform output pet-name
----------------
cat main.tf 
resource "random_pet" "my-pet" {

  length    = var.length 
}

output "pet-name" {

        value = random_pet.my-pet.id
        description = "Record the value of pet ID generated by the random_pet resource"
}

resource "local_file" "welcome" {
    filename = "/root/message.txt"
    content = "Welcome to Kodekloud."
}

output "welcom_message" {
        value = local_file.welcome.content
}

Outputs:
pet-name = "tomcat"
welcom_message = "Welcome to Kodekloud."


#################
Terraform State
save into terraform.tfstate file and stored siticie information

################
Working with terraform
# 1 Terraform Commands
terraform validate # check file Success! the configuration is valid
terraform fmt   # terraform format command -- main.tf auto mofify format for file
terraform show
terraform show -json
terraform providers  # See a list all providers 
terraform providers mirror /root/terraform/new_local_file
terraform output 
terraform output pet-name
terraform plan
terraform apply -refresh-only
terraform graph
  apt update
  apt install graphviz -y
  terraform graph | dot -Tsvg > graph.svg
-------------------------------------------
## Mutable vs Immutable Infrastructure
## LifeCycle Rules
Create before destroy
#Created then delete
main.tf
resource "local_file" "pet" {
        filename = "/root/pets.txt"
        content = "My favorite pet"
        file_permission = "0700"

        Lifecycle {
          create_before_destroy  = true
         }
}
#Do not want a resource tobe destroyed for any reason -- accidentally deleted
main.tf
resource "local_file" "pet" {
        filename = "/root/pets.txt"
        content = "My favorite pet"
        file_permission = "0700"

        Lifecycle {
          prevent_destroy  = true
         }
}
*note: resourve still deleted when command terraform destroy
# Ignore change
main.tf
resource "aws_instance" "webserver" {
        ami = "ami-0eada"
        instance_type = "t2.micro"
        tags = {
          name  = "ProjectA-Webserver"
         }
        Lifecycle {
          ignore_changes  = [
            tags,ami
          ]
        }
}

ignore_changes  = all

##########################
Datasource
main.tf
resource "local_file" "pet" {
        filename = "/root/pets.txt"
        content = data.local_file.dog.content
}
data "local_file" "dog" {
  filename = "/root/dog.txt"
}

cat /root/dog.txt
Dogs are awesome!
---------------------------
Resource            data Source
keyword: resource   data
create,Update,Destroy  only reads infrastructure
also called Managed Resources  Also called Data resources
########
cat ebs.tf 
data "aws_ebs_volume" "gp2_volume" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }
}

cat s3.tf 
data "aws_s3_bucket" "selected" {
  bucket_name = "bucket.test.com"
}
###
---------------
### Meta-Arguments
- Shell Scripts
create_files.sh
#!/bin/bash
for i in {1..3}
  do 
    touch /root/pet${i}
  done 

ls -ltr /root

#Meta Arguments
#Count

main.tf
resource "local_file" "pet" {
        filename = "var.filename[count.index]"
        
        count =3
}

variables.tf
variable "filename" {
  defaul = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt"
}

terraform plan

main.tf
resource "local_file" "pet" {
        filename = "var.filename[count.index]"
        
        count = length(var.filename)
}

variables.tf
variable "filename" {
  defaul = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt"
}
#Length Function
Variable                              function          value
fruits=["apple", "banana", "orange"]  length(fruits)    3
cars = [ ]                            length(cars)      4
colors = []                           length(colors)    2

-------
main.tf
resource "local_file" "pet" {
        filename = "var.filename[count.index]"
        
        count = length(var.filename)
}
output "pets" {
  value = local_file.pet
}

terraform output
----------------------------------
#For_each
main.tf
resource "local_file" "pet" {
        filename = earch.value
        for_each = var.filename
}

variables.tf
variable "filename" {
  type=set(string)
  defaul = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt"
  ]
}
##
main.tf
resource "local_file" "pet" {
        filename = earch.value
        for_each = toset(var.filename)
}
output "pets" {
  value = local_file.pet
}


variables.tf
variable "filename" {
  type=list(string)
  defaul = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt"
  ]
}
-----> when we delete /root/pets.txt, resource then only 1 resource deptroyed
-----------
## Version Constraints
https://registry.terraform.io/providers/hashicorp/local/2.5.0

main.tf
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.0"
    }
  }
}
resource "local_file" "pet" {
        filename = earch.value
        for_each = toset(var.filename)
}
###
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "> 1.2.0, < 2.0.0, != 2.5.0" # specifically terraform not use ther version 2.5.0/ "~> 1.4.0"
    }
  }
}
-------------------
###################################################################
Terraform with AWS
# Getting Started with AWS
IAM 
AmazoneEC2FullAccess
AmazoneS3FullAccess
## 
User access to AWS
1. Username/ password
2. Access Key Secret Access Key
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x84_64-2.0.30.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

aws configure
AWS Access Key ID [None]: AKIAI..
AWS Secret Access Key : je7Mt
Default region name: us-west-2
Default output format: json

cat ./aws/config/config
cat ./config/credentials

aws iam create-user --user-name lucy
{
  "User": {
    "UserName": "Lucy",
    "Tags": []
    "CreateData": "",
    "UserId": "",
    "Path": "/",
    "Arn": "arn:aws:iam::0000000000000:user/lucy"
  }
}
aws s3api create-bucket -bucket my-bucket -region us-east-1
-----------------------------------------------------------
##AWS CLI
--endpoint http://aws:4566
aws --endpoint http://aws:4566 iam list-users
{
    "Users": [
        {
            "Path": "/",
            "UserName": "jill",
            "UserId": "5ovw086qggo048zwjqr5",
            "Arn": "arn:aws:iam::000000000000:user/jill",
            "CreateDate": "2025-08-06T03:52:03.408000+00:00"
        },
        {
            "Path": "/",
            "UserName": "jack",
            "UserId": "9rwu5f3pfogqplpgowyc",
            "Arn": "arn:aws:iam::000000000000:user/jack",
            "CreateDate": "2025-08-06T03:52:04.409000+00:00"
        }
    ]
}

aws --endpoint http://aws:4566 iam create-user --user-name mary
{
    "User": {
        "Path": "/",
        "UserName": "mary",
        "UserId": "c51pr1b1h1pjg6m2qw0t",
        "Arn": "arn:aws:iam::000000000000:user/mary",
        "CreateDate": "2025-08-06T03:57:46.750000+00:00"
    }
}
 cat /root/.aws/config 
[default]
region = us-east-1
cat /root/.aws/credentials 
[default]
aws_access_key_id = foo
aws_secret_access_key = bar

aws --endpoint http://aws:4566 iam attach-user-policy --user-name mary --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws --endpoint-url http://aws:4566 iam create-group --group-name project-sapphire-developers
{
    "Groups": [
        {
            "Path": "/",
            "GroupName": "project-sapphire-developers",
            "GroupId": "fk0hwbsfak7sv5wtb5ng",
            "Arn": "arn:aws:iam::000000000000:group/project-sapphire-developers",
            "CreateDate": "2025-08-06T04:11:33.066000+00:00"
        }
    ]
}
#add user to group
aws --endpoint-url http://aws:4566 iam add-user-to-group --group-name project-sapphire-developers --user-name jack
# check policies of group/user
aws --endpoint-url http://aws:4566 iam list-attached-group-policies --group-name project-sapphire-developers
{
    "AttachedPolicies": []
}
aws --endpoint-url http://aws:4566 iam list-attached-user-policies --user-name jack
{
    "AttachedPolicies": []
}
## add policies to group
aws --endpoint-url http://aws:4566 iam attach-group-policy --group-name project-sapphire-developers --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

❯ aws --endpoint-url http://aws:4566 iam list-attached-group-policies --group-name project-sapphire-developers
{
    "AttachedPolicies": [
        {
            "PolicyName": "AmazonEC2FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
        }
    ]
}
-----------------------------------------------------------
##AWS IAM with Terraform
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user

main.tf
provider "aws" {
  region = "us-west-2"
  access_key = "AKIAI"
  secret_key = "je7MtGbClwBF/"
}
resource "aws_iam_user" "admin-user" {
  name = "lucy"
  tags = {
    Description = "Technical Team Leader"
  }
}
##
terraform plan
terraform apply
-------
main.tf
resource "aws_iam_user" "admin-user" {
  name = "lucy"
  tags = {
    Description = "Technical Team Leader"
  }
}
.aws/cerdentials 
[default]
aws_access_key_id = foo
aws_secret_access_key = bar

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY_ID=
## IAM Policies with Teraform
main.tf
resource "aws_iam_user" "admin-user" {
  name = "lucy"
  tags = {
    Description = "Technical Team Leader"
  }
}

resource "aws_iam_policy" "adminUser" {
  name = "AdminUsers"
  policy = <EOF
    {
      "Version" "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "*",
          "resource": "*"
        }
      ]
    }
  EOF
}
resource "aws_iam_user_policy_attachment" "lucy-admin-access" {
  user = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.adminUser.arm
} 

terraform apply

## or
admin-policy.json
{
  "Version" "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "resource": "*"
    }
  ]
}

main.tf
resource "aws_iam_user" "admin-user" {
  name = "lucy"
  tags = {
    Description = "Technical Team Leader"
  }
}

resource "aws_iam_policy" "adminUser" {
  name = "AdminUsers"
  policy = file("admin-policy.json")
}
resource "aws_iam_user_policy_attachment" "lucy-admin-access" {
  user = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.adminUser.arm
} 

-----------------------
resource "aws_iam_user" "users" {
     name = var.project-sapphire-users[count.index]
     count = length(var.project-sapphire-users)
}
cat variables.tf 
variable "project-sapphire-users" {
     type = list(string)
     default = [ "mary", "jack", "jill", "mack", "buzz", "mater"]
}
----------------------------
## AWS S3 with Terraform

main.tf
resource "aws_s3_bucket" "finance" {
  bucket = "finanace-21092020"
  tags = {
    Description = "Finance and Payroll"
  }
}

resource "aws_s3_bucket_object" "finance-2020" {
  content = "/root/finance/finance-2020.doc"
  key = "finance-2020.doc"
  bucket = "aws_s3_bucket.finance.id"
}
data "aws_iam_group" "finance-data" {  ## this group is not create by terraform
  group_name = "finance-analysts"
}

resource "aws_s3_bucket_policy" "finance-policy" {
  bucket = aws_s3_bucket.finance.id
  policy = <EOF
    {
      "Version" "2012-10-17",
      "Statement": [
        { 
          "Effect": "Allow",
          "Action": "*",
          "Resource": "arn:aws:s3:::${aws_s3_bucket.finance.id}/*",
          "Principal": {
            "AWS": [
              "${data.aws_iam_group.finance-data.arn}"

            ]
          }
        }
      ]
    }
  EOF
}

#################
#Introduction to DynamoDB
############################
## Remote State
#Remote Backends with S3
terraform.tf
terraform {
  backend "s3"  {
    bucket = "kodekloud-terraform-state-bucket01"
    key  = "finance/terraform.tfstate"
    region = "us-west-1"
    dynamodb_table = "state-locking"
  }
}

main.tf
resource "local_file" "pet" {
        filename = "/root/pets.txt"
        content = data.local_file.dog.content
}

## Terraform State Commands
terraform state show aws_s3_bucket.finance
terraform state <subcommand> [options] [args]
Sub-command
list, mv, pull, rm, show

terraform state mv aws_dynamodb_table.state-locking aws_dynamodb_stable.state-locking-db
terraform state pull | jq '.resources[] | select(.name == "state-locking-db) | .instances[].attributes.hash_key'
"LockID"
terraform state rm aws_s3_bucket.finace-2020922
#######################
### Terraform Provision
# Terraform deploying EC2
main.tf

resource "aws_instance" "webserver" {
  ami = "ami-0edab43b6fa892279"
  instance_type = "t2.micro"
  tags = {
    name = "webserver"
    Description = "An nginx webserver on ubuntu"
  }
  user_data = <-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    systemctl enable nginx
    systemctl start nginx
    EOF
  key_name = aws_key_pair.web.id
  vpc_security_group_ids = [ aws_security_group.ssh-access.id ]
}
resource "aws_key_pair" "web" {
  public_key = file("/root/.ssh/web.pub")
}
resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "Allow SSH access from the Internet"
    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output publicip {
  value = aws_instance-webserver.public_ip
}
preovider.tf
provider "aws" {
  region = "us-west-2"
  access_key = "AKIAI"
  secret_key = "je7MtGbClwBF/"
}

## Terraform Provisioners
# Remote Exec
main.tf

esource "aws_instance" "webserver" {
ami = "ami-0edab43b6fa892279"
instance_type = "t2.micro"
}
user_data = <-EOF
#!/bin/bash
sudo apt update
sudo apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF
resource "aws_key_pair" "web" {
}

# Local Exec
main.tf

resource "aws_instance" "webserver" {
  ami = "ami-0edab43b6fa892279"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo ${aws_instance.webserver2.public_ip} >> /tmp/ips.txt"
  }
}
cat /tmp/ips.txt

resource "aws_instance" "webserver" {
  ami = "ami-0edab43b6fa892279"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    on_failure = fail # or continue
    command = "echo $Instance ${aws_instance.webserver2.public_ip} Created! > /tmp/instance_state.txt"
  }
  provisioner "local-exec" {
    when = destroy
    command = "echo $Instance ${aws_instance.webserver2.public_ip} Destroyed! > /tmp/instance_state.txt"
  }
}

cat /tmp/instance_state.txt
Instance ip Create!
Instance ip Deleted!
---------------
cat main.tf 
resource "aws_instance" "cerberus" {
  ami = var.ami
  instance_type = var.instance_type
}
variable "ami" {
  default = "ami-06178cf087598769c"
}
variable "instance_type" {
  default = "m5.large"
}
variable "region" {
  default = "eu-west-2"
}

###################
##Terraform Taint
Terraform taint aws_instance.webserver
terraform untaint aws_instance.webserver
# Debugging
export TF_LOG=TRACE 
export TF_LOG_PATH=/tmp/terraform.log
head -10 /tmp/terraform.log
#remove log
unset TF_LOG_PATH

## Terraform Import
#Data source
main.tf 
data "aws_instance" "newserver" {
  instance_id = "i-026213be10d5326f7"
}
output newserver {
  value = data.aws_instance.newserver.public_ip
}
#Terraform import
terraform inport <resource_type>.<resource_name> <attribute>
terraform import aws_instance.webserver-2 i-20

main.tf
resource "aws_instance" "webserver-2" {
  #(resource arguments)
}
terraform import aws_instance.webserver-2 i-20

aws ec2 create-key-pair --endpoint http://aws:4566 --key-name jade --query 'KeyMaterial' --output text > /root/terraform-projects/project-jade/jade.pem

aws ec2 describe-instances --endpoint http://aws:4566

aws ec2 describe-instances --endpoint http://aws:4566  --filters "Name=image-id,Values=ami-082b3eca746b12a89" | jq -r '.Reservations[].Instances[].InstanceId'


aws ec2 describe-instances --filters "Name=tag:Name,Values=jade-mw" --query "Reservations[*].Instances[*].[ImageId, InstanceType, KeyName, Tags]" --endpoint http://aws:4566
##
############
##Terraform modules
resource aws
aws_instance
aws_key_pair
aws_iam_policy
aws_s3_bucket
aws_dynamodb_table
aws_instance

main.tf
module "dev-webserver" {
  source = "../aws-instance"
}
#create and using a module
mkdir /root/terraform-projects/modules/payroll-app

app_server.tf
resource "aws_instance" "app_server" {
  ami = var.ami
  instance_type = "t2.medium"
  tags = {
    Name = "${var.app_region}-app-server"
  }
  depends_on = [ aws_dynamodb_table.payroll_db,
                 aws_s3_bucket.payroll_data
               ]
}

dynamodb_table.tf
resource "aws_dynamodb_table" "payroll_db" {
  name = "user_data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "EmployeeID"
  attribute {
    name = "EmployeeID"
    type = "N"
  }
}

s3_bucket.tf
resource "aws_s3_bucket" "payroll_data" {
  bucket = "${var.app_region}-${var.bucket}"
}

variables.tf
variable "app_region" {
  type = string
}
variable "bucket" {
  default = "flexit-payroll-alpha-22001c"
}
variable "ami" {
  type = string
}
------------------------------------
mkdir /root/terraform-projects/us-payroll-app

main.tf
module "us_payroll" {
  source = "../modules/payroll-app"
  app_region = "us-east-1"
  ami = "ami-24e140119877avm"
}

mkdir /root/terraform-projects/uk-payroll-app

main.tf
module "uk_payroll" {
  source = "../modules/payroll-app"
  app_region = "es-east-2"
  ami = "ami-24e140119877avm"
}

## Using Modules from Registry
main.tf
module "security-group_ssh" {
  source = "terraform-aws-modules/security-group/aws/modules/ssh"
  version = "3.16.0"
  vpc_id = "vpc-7d8d215"
  ingress_cidr_blocks = [ "10.10.0.0/16" ]
  name = "ssh-access"
}
terraform get

### Terraform Functions
terraform console
>file("root/terraform/main.tf")
>lenghth(var.region)
>toset(var.region)

>max(var.num...)
>min(var.num...)
>split(",", "",)
>lower(var.ami)
>upper
>title()
substr
>lenghth(var.ami)
>element(var.ami,2)
>contains(var.ami, "ABC")
>keys(var.ami)
>value(var.ami)
>lookup(var.ami, "")
########
#Terraform Workspaces
terraform wrokspace new ProjectA
terraform wrokspace new ProjectB
terraform wrokspace select ProjectA
terraform workspace list 

terraform console
>terraform.workspace
ProjectA 

variables.tf
variable region {
  default = "ca-central-1"
}
variable instance_type {
  default = "t2.micro"
}
variable ami {
  type = map
  default = {
    "ProjectA" = "ami-0edab43b6fa892279",
    "ProjectB" = "ami-0c2f25c1f66a1ff4d"
  }
}

main.tf
resource "aws_instance" "projectA" {
  ami = lookup(var.ami, terraform.workspace)
  instance_type = var.instance)type 
  tags = {
    Name = terraform.workspace
  }
}


var.instance_type
terraform.workspace
lookup(var.ami, terraform.workspace)
>_
> terraform.workspace
ProjectA
> lookup(var.ami, terraform.workspace)
ami-0edab43b6fa892279