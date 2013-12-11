# Copyright 2013 Hewlett-Packard Development Company, L.P.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

# This is a one-off, it should not be included in the highstate
# Run with: salt $esnode state.sls elasticsearch.upgrade ; salt $esnode state.highstate

# For online upgrades (no downtime) target each cluster node individually
# and wait for it to rejoin the cluster before moving on.
# Online upgrades are supported for 0.90.x -> 0.90.x+n
# Online upgrades from 0.90.0 -> 0.90.7 are known to break, instead leap-frog off of 0.90.5

{% set deb = pillar.get('elasticsearch:deb_url', 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.deb') %}

remove_old_elasticsearch:
  pkg.purged:
    - name: elasticsearch

install_new_elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: {{ deb }}
    - require:
      - pkg: remove_old_elasticsearch
