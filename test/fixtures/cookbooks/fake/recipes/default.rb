# Open the SSH port so we retain access

include_recipe 'debnetwork'

firewall 'ufw' do
  action :nothing
end

firewall_rule 'ssh' do
  port      22
  protocol  :tcp
  action    :allow
  notifies  :enable, 'firewall[ufw]'
end


# Test network setup using the LWRP

debnetwork 'net' do

  send_redirects  :disable

  postrouting '-s 10.10.10.10 -j MASQUERADE'

  forward '-m state --state RELATED,ESTABLISHED -j ACCEPT'
  forward '-j ACCEPT'

end
