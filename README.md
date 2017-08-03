# RCS SQL Workshop AWS Environment

This repository contains a cloudformation template that will create an
environment for teaching a SQL workshop. It creates the following resourcs:

- VPC security group
- PostgreSQL RDS instance
- EC2 instance

And then on the EC2 instance, a user data script is run that will create an
example database on the RDS instance and create SSH and database logins for the
students.

The URL of a file containing the usernames of all students must be provided as a
parameter. Each user's password will just be their username spelled backwards.