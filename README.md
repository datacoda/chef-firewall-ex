debnetwork cookbook
===================
Simple networking LWRP for Debian/Ubuntu nodes.

Includes guards for OpenVZ.


Requirements
------------

Depends on the `firewall` cookbook.


Usage
-----
Including the default recipe will allow access to the LWRP

```ruby
debnetwork 'net' do
    ipv4_preferred true
    send_redirects :disable

    postrouting '-s 10.10.10.10 -j MASQUERADE'

    forward '-m state --state RELATED,ESTABLISHED -j ACCEPT'
    forward '-j ACCEPT'
end
```


Attributes
----------


Recipes
-------

### default
Enables usage of the LWRP `debnetwork`


License & Authors
-----------------
- Author:: Ted Chen (<ted@nephilagraphic.com>)

```text
Copyright 2014, Nephila Graphic

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