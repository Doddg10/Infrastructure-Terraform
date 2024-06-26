vpc_cidr="12.0.0.0/16"
machine_type="t2.micro"
region="us-east-1"

subnets_details-AZ1=[

{
    name="public_subnet1",
    cidr="12.0.1.0/24",
    type="public"
},

{
    name="private_subnet1",
    cidr="12.0.3.0/24",
    type="private"
},
]

subnets_details-AZ2=[

{
    name="public_subnet2",
    cidr="12.0.2.0/24",
    type="public"
},

{
    name="private_subnet2",
    cidr="12.0.4.0/24",
    type="private"
}
]

db_username="admin"
db_password="admin12345678"