# frozen_string_literal: true

elb_fqdn = attribute(
  "elb_fqdn",
  description: "The Terraform configuration under test must define an " \
  "equivalently named output",
)

control "inspec_attributes" do

  describe elb_fqdn do
    it { should match /(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)/ }
  end

end