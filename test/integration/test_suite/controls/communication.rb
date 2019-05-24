# frozen_string_literal: true

ec2_ip = attribute(
    "ec2_ip",
    description: "The Terraform configuration under test must define the " \
    "equivalently named output",
  )
  
  control "reachable_ssh" do
    desc "Verifies that the other host is reachable from the current host"
  
    describe host ec2_ip do
      it { should be_reachable }
    end
  end
  
# frozen_string_literal: true

elb_fqdn = attribute(
    "elb_fqdn",
    description: "The Terraform configuration under test must define the " \
    "equivalently named output",
  )
  
  control "reachable_website" do
    desc "Verifies that the other host is reachable from the current host"
  
    describe host(elb_fqdn, port: 80, protocol: 'tcp') do
      it { should be_reachable }
     # its('connection') { should_not match /connection refused/
      it { should be_resolvable }
    end
  end
  