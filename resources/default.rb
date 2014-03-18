#
# Cookbook Name:: debnetwork
# Resource:: default
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

actions :enable, :disable

attribute :name,                :kind_of => String, :name_attribute => true

attribute :ipv4_preferred,      :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['ipv4_preferred']
attribute :ipv6_enabled,        :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['ipv6_enabled']

attribute :send_redirects,      :kind_of => Symbol, :equal_to => [:enable, :disable], :default => node['debnetwork']['send_redirects']
attribute :postrouting_rules,   :kind_of => Array
attribute :postrouting6_rules,  :kind_of => Array
attribute :forward_rules,       :kind_of => Array
attribute :forward6_rules,      :kind_of => Array


def initialize(*args)
  super
  @postrouting_rules = node['debnetwork']['postrouting_rules'].dup
  @postrouting6_rules = node['debnetwork']['postrouting6_rules'].dup
  @forward_rules = node['debnetwork']['forward_rules'].dup
  @forward6_rules = node['debnetwork']['forward6_rules'].dup
  @action = :enable
end


def postrouting(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @postrouting_rules << rule
end

def forward(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @forward_rules << rule
end