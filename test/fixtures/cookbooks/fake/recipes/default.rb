include_recipe 'apt'

# Open the SSH port so we retain access

include_recipe 'firewall-ex'

firewall_rule 'ssh' do
  port 22
  protocol :tcp
  action :allow
end

# Test network setup using the LWRP

firewall_ex 'my_ufw' do
  ipv4_forward true

  accept_redirects false
  send_redirects false

  input '-p esp -j ACCEPT'
  output '-p esp -j ACCEPT'

  postrouting '-s 10.10.10.10 -j MASQUERADE'

  forward '-m state --state RELATED,ESTABLISHED -j ACCEPT'
  forward '-j ACCEPT'

  action :enable
end
