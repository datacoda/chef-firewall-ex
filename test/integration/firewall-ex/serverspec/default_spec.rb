require 'spec_helper'

# Debian uses plain init.d scripts
if os[:family] != 'debian'
  describe service('ufw') do
    it { should be_enabled }
    it { should be_running }
  end
end

# Check ports
describe port(22) do
  it { should be_listening.with('tcp') }
end

describe port(80) do
  it { should_not be_listening.with('tcp') }
end

# Check that test users are created
describe file('/etc/ufw/before.rules') do
  # This is from the kitchen data_bag
  its(:content)  { should match(/-A POSTROUTING -s 10.10.10.11 -j MASQUERADE/) }
  its(:content)  { should match(/-A ufw-before-forward -m state -s 10.10.10.11 --state RELATED,ESTABLISHED -j ACCEPT/) }

  # This is from the LWRP
  its(:content)  { should match(/-A ufw-before-input -p esp -j ACCEPT/) }
  its(:content)  { should match(/-A ufw-before-output -p esp -j ACCEPT/) }

  its(:content)  { should match(/-A POSTROUTING -s 10.10.10.10 -j MASQUERADE/) }

  its(:content)  { should match(/-A ufw-before-forward -m state --state RELATED,ESTABLISHED -j ACCEPT/) }
  its(:content)  { should match(/-A ufw-before-forward -j ACCEPT/) }
end

describe file('/etc/ufw/sysctl.conf') do
  its(:content) { should match %r{net/ipv4/conf/all/accept_redirects=0} }
  its(:content) { should match %r{net/ipv4/conf/all/send_redirects=0} }
end
