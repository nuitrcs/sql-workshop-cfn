 # RCS SQL Workshop AWS Environment

This repository contains a cloudformation template that will create an
environment for teaching a SQL workshop. It creates the following resourcs:

- VPC security group
- PostgreSQL RDS instance
- EC2 instance

And then on the EC2 instance, a user data script is run that will create an
example database on the RDS instance and create SSH and database logins for the
students.

The S3 URL of a file containing the usernames of all students must be provided
as a parameter. Each user's password will just be their username spelled
backwards. The default value for this parameter is
`s3://nuitrcs-resources/netids.txt`.

## How to use this Cloudformation Template

1. Create a text file containing the usernames of all workshop attendees, one
   per line, and upload it to an S3 bucket accessible by the IAM role referenced
   by the `InstanceProfileName` parameter. For RCS, this S3 bucket is called
   `nuitrcs-resources`.

2. Create the stack using the following command:

    ```
    aws cloudformation create-stack --stack-name <stack name> --region us-east-2 --template-body file://sql-workshop-stack.yml --parameters ParameterKey=EC2KeyName,ParameterValue=<key name> ParameterKey=RDSInstanceType,ParameterValue=<rds instance type> ParameterKey=EC2InstanceType,ParameterValue=<ec2 instance type> ParameterKey=NetIdFileUri,ParameterValue=<s3 uri of uploaded file>
    ```

3. Once the stack is created (this may take as long as 15 minutes), look at the
   Outputs section of the stack detail in the AWS console to retrieve the
   address of the EC2 instance and the RDS instance.

4. Instruct users to ssh into the EC2 instance using their username (as given in
   the uploaded text file) as both login and password (that is, their password
   is their username).

5. Once logged in, they can use the `psql` command to connect to the database,
   using the following command:

    ```
    psql dvdrental
    ```

The users will be prompted to provide their password when connecting, which is
the same password they used to connect via ssh.