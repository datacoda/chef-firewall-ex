#
# Cookbook Name:: firewall-ex
# Resource:: default
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

actions :install, :restart, :disable, :flush

attribute :name, kind_of: String, name_attribute: true

attribute :ipv4_forward, kind_of: [TrueClass, FalseClass], default: node['firewall-ex']['ipv4_forward']
attribute :ipv6_forward, kind_of: [TrueClass, FalseClass], default: node['firewall-ex']['ipv6_forward']
attribute :ipv6_enabled, kind_of: [TrueClass, FalseClass], default: node['firewall-ex']['ipv6_enabled']

attribute :accept_redirects, kind_of: [TrueClass, FalseClass], default: node['firewall-ex']['accept_redirects']
attribute :send_redirects, kind_of: [TrueClass, FalseClass], default: node['firewall-ex']['send_redirects']

attribute :input_rules, kind_of: Array
attribute :output_rules, kind_of: Array
attribute :postrouting_rules, kind_of: Array
attribute :forward_rules, kind_of: Array
attribute :forward6_rules, kind_of: Array

def initialize(*args)
  super
  @input_rules = node['firewall-ex']['input_rules'].dup
  @output_rules = node['firewall-ex']['output_rules'].dup
  @postrouting_rules = node['firewall-ex']['postrouting_rules'].dup
  @forward_rules = node['firewall-ex']['forward_rules'].dup
  @forward6_rules = node['firewall-ex']['forward6_rules'].dup
  @action = :install
end

def input(rule)
  @input_rules << rule
end

def output(rule)
  @output_rules << rule
end

def postrouting(rule)
  @postrouting_rules << rule
end

def forward(rule)
  @forward_rules << rule
end

def forward6(rule)
  @forward6_rules << rule
end
