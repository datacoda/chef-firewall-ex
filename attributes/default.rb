#
# Cookbook Name:: firewall-ex
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

default['firewall-ex']['ipv4_forward'] = false
default['firewall-ex']['ipv6_forward'] = false
default['firewall-ex']['ipv6_enabled'] = false

default['firewall-ex']['accept_redirects'] = false
default['firewall-ex']['send_redirects'] = true

default['firewall-ex']['input_rules'] = []
default['firewall-ex']['output_rules'] = []
default['firewall-ex']['postrouting_rules'] = []
default['firewall-ex']['forward_rules'] = []
default['firewall-ex']['forward6_rules'] = []

default['firewall-ex']['after_rules']['template_source'] = 'after.rules.erb'
default['firewall-ex']['after_rules']['template_cookbook'] = 'firewall-ex'

default['firewall-ex']['after6_rules']['template_source'] = 'after6.rules.erb'
default['firewall-ex']['after6_rules']['template_cookbook'] = 'firewall-ex'

default['firewall-ex']['before_rules']['template_source'] = 'before.rules.erb'
default['firewall-ex']['before_rules']['template_cookbook'] = 'firewall-ex'

default['firewall-ex']['before6_rules']['template_source'] = 'before6.rules.erb'
default['firewall-ex']['before6_rules']['template_cookbook'] = 'firewall-ex'

default['firewall-ex']['default_ufw']['template_source'] = 'default.erb'
default['firewall-ex']['default_ufw']['template_cookbook'] = 'firewall-ex'

default['firewall-ex']['sysctl_conf']['template_source'] = 'sysctl.conf.erb'
default['firewall-ex']['sysctl_conf']['template_cookbook'] = 'firewall-ex'
