#
# Cookbook Name:: debnetwork
# Attributes:: default
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

default['debnetwork']['ipv4_forward'] = false
default['debnetwork']['ipv4_preferred'] = false
default['debnetwork']['ipv6_forward'] = false
default['debnetwork']['ipv6_enabled'] = true

# Automatically turn off ipv6 if no global exists
interfaces = node['network']['interfaces']
ipv6found = interfaces.select do |iface, _|
              interfaces[iface]['addresses'].select do |_, adata|
                adata['scope'] == 'Global' && adata['family'] == 'inet6'
              end.length > 0
            end

if ipv6found.empty?
  override['debnetwork']['ipv6_enabled'] = false
end

default['debnetwork']['accept_redirects'] = false
default['debnetwork']['send_redirects'] = true

default['debnetwork']['input_rules'] = [ ]
default['debnetwork']['output_rules'] = [ ]
default['debnetwork']['postrouting_rules'] = [ ]
default['debnetwork']['forward_rules'] = [ ]
default['debnetwork']['forward6_rules'] = [ ]

default['debnetwork']['after_rules']['template_source']      = 'ufw/after.rules.erb'
default['debnetwork']['after_rules']['template_cookbook']    = 'debnetwork'

default['debnetwork']['after6_rules']['template_source']     = 'ufw/after6.rules.erb'
default['debnetwork']['after6_rules']['template_cookbook']   = 'debnetwork'

default['debnetwork']['before_rules']['template_source']     = 'ufw/before.rules.erb'
default['debnetwork']['before_rules']['template_cookbook']   = 'debnetwork'

default['debnetwork']['before6_rules']['template_source']    = 'ufw/before6.rules.erb'
default['debnetwork']['before6_rules']['template_cookbook']  = 'debnetwork'

default['debnetwork']['default_ufw']['template_source']      = 'ufw/default.erb'
default['debnetwork']['default_ufw']['template_cookbook']    = 'debnetwork'

default['debnetwork']['sysctl_conf']['template_source']      = 'ufw/sysctl.conf.erb'
default['debnetwork']['sysctl_conf']['template_cookbook']    = 'debnetwork'