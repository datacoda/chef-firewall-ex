#
# Cookbook Name:: debnetwork
# Recipe:: default
#
# Copyright (C) 2014 Nephila Graphic
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Fixes ufw on OpenVZ systems.
# This overwrites the after/before/default configuration files.


include_recipe 'firewall'

firewall_rule 'ssh' do
  port          22
  protocol      :tcp
  action        :allow
  notifies      :enable, 'firewall[ufw]'
end

is_openvz_ve = node['virtualization']['system'] == 'openvz' && node['virtualization']['role'] == 'guest'

template "/etc/ufw/before.rules" do
  source      node['debnetwork']['before_rules']['template_source']
  cookbook    node['debnetwork']['before_rules']['template_cookbook']
  mode        00640
  variables(
      :is_openvz_ve => is_openvz_ve
  )
  notifies    :enable, 'firewall[ufw]', :delayed
end

template "/etc/ufw/before6.rules" do
  source      node['debnetwork']['before6_rules']['template_source']
  cookbook    node['debnetwork']['before6_rules']['template_cookbook']
  mode        00640
  variables(
      :is_openvz_ve => is_openvz_ve
  )
  notifies    :enable, 'firewall[ufw]', :delayed
end


template "/etc/ufw/after.rules" do
  source      node['debnetwork']['after_rules']['template_source']
  cookbook    node['debnetwork']['after_rules']['template_cookbook']
  mode        00640
  variables(
      :is_openvz_ve => is_openvz_ve
  )
  notifies    :enable, 'firewall[ufw]', :delayed
end

template "/etc/ufw/after6.rules" do
  source      node['debnetwork']['after6_rules']['template_source']
  cookbook    node['debnetwork']['after6_rules']['template_cookbook']
  mode        00640
  variables(
      :is_openvz_ve => is_openvz_ve
  )
  notifies    :enable, 'firewall[ufw]', :delayed
end


disable_send_redirects = []
if node['debnetwork']['send_redirects']['action'] === 'disable'
  disable_send_redirects = node['debnetwork']['send_redirects']['interfaces']
end

template "/etc/ufw/sysctl.conf" do
  source      node['debnetwork']['sysctl_conf']['template_source']
  cookbook    node['debnetwork']['sysctl_conf']['template_cookbook']
  mode        00644
  variables(
      :is_openvz_ve => is_openvz_ve,
      :disable_send_redirects => disable_send_redirects
  )
  notifies    :enable, 'firewall[ufw]', :delayed
end

# Disable IPv6 on OpenVZ
template "/etc/default/ufw" do
  source      node['debnetwork']['default_ufw']['template_source']
  cookbook    node['debnetwork']['default_ufw']['template_cookbook']
  mode        00644
  variables(
      :is_openvz_ve => is_openvz_ve,
      :enable_ipv6 => node['debnetwork']['enable_ipv6']
  )
  notifies    :enable, 'firewall[ufw]', :delayed
end

# Prefer ipv4 in gai.conf since ipv6 is blocked now.
template "/etc/gai.conf" do
  source "gai.conf.erb"
  variables(
      :is_openvz_ve => is_openvz_ve
  )
  mode 00644
end



firewall 'ufw' do
  action :nothing
end