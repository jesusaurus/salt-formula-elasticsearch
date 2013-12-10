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

# Dashboard, available at http://elasticsearch:9200/_plugin/paramedic/index.html
# displays basic information about your cluster: cluster name, health,
# number of nodes and shards, etc., using the Cluster Health API.

include:
  - elasticsearch

# we have our own deb built form this
# https://github.com/karmi/elasticsearch-paramedic
# TODO: replace custom deb with this sls
#
# Dashboard, available at http://elasticsearch:9200/_plugin/paramedic/index.html
# displays basic information about your cluster: cluster name, health,
# number of nodes and shards, etc., using the Cluster Health API.
elasticsearch-paramedic:
  pkg.installed:
    - require:
      - pkg: elasticsearch
