#
# Cookbook Name:: firewall-ex
# Provider:: default
#
# Copyright 2014-2016 Nephila Graphic, Li-Te Chen
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

action :enable do
  new_resource.updated_by_last_action(
      setup_firewall(new_resource, :enable)
  )
end

action :disable do
  new_resource.updated_by_last_action(
      setup_firewall(new_resource, :disable)
  )
end

private

def setup_firewall(new_resource, new_action)
  firewall new_resource.name do
    action new_action
  end

  # OpenVZ requires some fine tuning for UFW
  is_openvz_ve = node['virtualization']['system'] == 'openvz' && node['virtualization']['role'] == 'guest'

  template '/etc/ufw/before.rules' do
    source node['firewall-ex']['before_rules']['template_source']
    cookbook node['firewall-ex']['before_rules']['template_cookbook']
    mode 00640
    variables(
      is_openvz_ve: is_openvz_ve,
      input_rules: new_resource.input_rules,
      output_rules: new_resource.output_rules,
      postrouting_rules: new_resource.postrouting_rules,
      forward_rules: new_resource.forward_rules
    )
    notifies :restart, 'service[ufw]'
  end

  template '/etc/ufw/before6.rules' do
    source node['firewall-ex']['before6_rules']['template_source']
    cookbook node['firewall-ex']['before6_rules']['template_cookbook']
    mode 00640
    variables(
      is_openvz_ve: is_openvz_ve,
      forward_rules: new_resource.forward6_rules
    )
    notifies :restart, 'service[ufw]'
  end

  template '/etc/ufw/after.rules' do
    source node['firewall-ex']['after_rules']['template_source']
    cookbook node['firewall-ex']['after_rules']['template_cookbook']
    mode 00640
    variables(
      is_openvz_ve: is_openvz_ve
    )
    notifies :restart, 'service[ufw]'
  end

  template '/etc/ufw/after6.rules' do
    source node['firewall-ex']['after6_rules']['template_source']
    cookbook node['firewall-ex']['after6_rules']['template_cookbook']
    mode 00640
    variables(
      is_openvz_ve: is_openvz_ve
    )
    notifies :restart, 'service[ufw]'
  end

  # Send redirects aren't normally in the sysctl file.  We'll need to pull
  # up all the interfaces
  send_redirects_rules = []
  send_redirects_value = new_resource.send_redirects ? 1 : 0

  Dir['/proc/sys/net/ipv4/conf/*/send_redirects'].each do |interface|
    interface.sub!(%r{/proc/sys/}, '')
    send_redirects_rules << "#{interface}=#{send_redirects_value}"
  end

  template '/etc/ufw/sysctl.conf' do
    source node['firewall-ex']['sysctl_conf']['template_source']
    cookbook node['firewall-ex']['sysctl_conf']['template_cookbook']
    mode 00644
    variables(
      is_openvz_ve: is_openvz_ve,
      ipv4_forward: new_resource.ipv4_forward,
      ipv6_forward: new_resource.ipv6_forward,
      accept_redirects: new_resource.accept_redirects,
      send_redirects_rules: send_redirects_rules
    )
    notifies :restart, 'service[ufw]'
  end

  # Disable IPv6 on OpenVZ
  template '/etc/default/ufw' do
    source node['firewall-ex']['default_ufw']['template_source']
    cookbook node['firewall-ex']['default_ufw']['template_cookbook']
    mode 00644
    variables(
      is_openvz_ve: is_openvz_ve,
      ipv4_forward: new_resource.ipv4_forward,
      ipv6_enabled: new_resource.ipv6_enabled
    )
    notifies :restart, 'service[ufw]'
  end

  # Used to reload before/after rules as needed
  r = service 'ufw' do
    case node['platform']
    when 'ubuntu'
      provider Chef::Provider::Service::Upstart
    when 'debian'
      provider Chef::Provider::Service::Init::Debian
    end
    supports status: true,
             restart: true,
             start: true,
             stop: true
    action :nothing
  end

  r.updated_by_last_action?
end
