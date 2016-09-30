firewall-ex cookbook
===================
![Latest cookbook](https://img.shields.io/cookbook/v/firewall-ex.svg)
![Tag](https://img.shields.io/github/tag/dataferret/chef-firewall-ex.svg)
[![Build Status](https://travis-ci.org/dataferret/chef-firewall-ex.svg?branch=master)](https://travis-ci.org/dataferret/chef-firewall-ex)

Simple networking LWRP for Debian/Ubuntu nodes.

Extends 'firewall' to incorporate after, before, and sysctl rules as part of the firewall configuration.

Includes also guards for OpenVZ containers.

Tested on

* Ubuntu 12.04
* Ubuntu 14.04
* Debian 7

Requirements
------------

Depends on the `firewall` cookbook.


Usage
-----
Including the default recipe will allow access to the LWRP along with install the base 'firewall::default' recipe.  Just use in place of the normal firewall LWRP.

```ruby
firewall_ex 'net' do
  send_redirects false

  postrouting '-s 10.10.10.10 -j MASQUERADE'

  forward '-m state --state RELATED,ESTABLISHED -j ACCEPT'
  forward '-j ACCEPT'

  action :enable
end
```


Attributes
----------

### Default

* `node['firewall-ex']['ipv4_forward']` - sets the ip_forward flag in sysctl.
* `node['firewall-ex']['ipv6_forward']` - sets the ipv6 forwarding rules in sysctl.
* `node['firewall-ex']['ipv6_enabled']` - apply rules to support IPv6

* `node['firewall-ex']['accept_redirects']` - sets the accept_redirects flags in sysctl.
* `node['firewall-ex']['send_redirects']` - sets the send_redirects flags in sysctl.

The following firewall iptables rules can also be set as an array of lines.

* `node['firewall-ex']['input_rules']` - 
* `node['firewall-ex']['output_rules']` - 
* `node['firewall-ex']['postrouting_rules']` - 
* `node['firewall-ex']['forward_rules']` - 
* `node['firewall-ex']['forward6_rules']` - 

Those that are directly defined in the LWRP are appended to these lists which are empty by default.


Recipes
-------

### default
Enables usage of the LWRP `firewall_ex`


License & Authors
-----------------
- Author:: Li-Te Chen (<datacoda@gmail.com>)

```text
Copyright 2014-2016, Nephila Graphic, Li-Te Chen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
