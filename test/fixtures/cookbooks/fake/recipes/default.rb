# Open the SSH port so we retain access

include_recipe 'firewall-ex'

firewall 'ufw' do
  action :nothing
end

firewall_rule 'ssh' do
  port 22
  protocol :tcp
  action :allow
  notifies :enable, 'firewall[ufw]'
end

# Test network setup using the LWRP

firewall_ex 'net' do
  ipv4_forward true

  accept_redirects false
  send_redirects false

  input '-p esp -j ACCEPT'
  output '-p esp -j ACCEPT'

  postrouting '-s 10.10.10.10 -j MASQUERADE'

  forward '-m state --state RELATED,ESTABLISHED -j ACCEPT'
  forward '-j ACCEPT'
end
