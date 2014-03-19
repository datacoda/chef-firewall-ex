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

attribute :ipv4_forward,        :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['ipv4_forward']
attribute :ipv4_preferred,      :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['ipv4_preferred']
attribute :ipv6_forward,        :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['ipv6_forward']
attribute :ipv6_enabled,        :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['ipv6_enabled']

attribute :accept_redirects,    :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['accept_redirects']
attribute :send_redirects,      :kind_of => [TrueClass, FalseClass], :default => node['debnetwork']['send_redirects']

attribute :input_rules,         :kind_of => Array
attribute :output_rules,        :kind_of => Array
attribute :postrouting_rules,   :kind_of => Array
attribute :forward_rules,       :kind_of => Array
attribute :forward6_rules,      :kind_of => Array


def initialize(*args)
  super
  @input_rules = node['debnetwork']['input_rules'].dup
  @output_rules = node['debnetwork']['output_rules'].dup
  @postrouting_rules = node['debnetwork']['postrouting_rules'].dup
  @forward_rules = node['debnetwork']['forward_rules'].dup
  @forward6_rules = node['debnetwork']['forward6_rules'].dup
  @action = :enable
end

def input(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @input_rules << rule
end

def output(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @output_rules << rule
end

def postrouting(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @postrouting_rules << rule
end

def forward(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @forward_rules << rule
end


def forward6(rule)
  validate({ :rule => rule }, { :rule => { :kind_of => String }})
  @forward6_rules << rule
end