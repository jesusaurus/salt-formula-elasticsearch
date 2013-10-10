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
requirements:
  pkg.installed:
    - pkgs:
      - openjdk-7-jre-headless
      - curl

elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.deb
    - require:
      - pkg: requirements
  service:
    - running
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/security/limits.conf

/etc/default/elasticsearch:
  file:
    - sed
    - before: '#ES_HEAP_SIZE=2g'
    - after: ES_HEAP_SIZE={{ (grains['mem_total']/2)|round|int }}m
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/elasticsearch.yml:
  file:
    - managed
    - source: salt://elasticsearch/templates/elasticsearch.yml.jinja
    - template: jinja
    - require:
      - pkg: elasticsearch

#
# Dashboard, available at http://elasticsearch:9200/_plugin/paramedic/index.html
# displays basic information about your cluster: cluster name, health,
# number of nodes and shards, etc., using the Cluster Health API.
/usr/share/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic:
  cmd:
    - run
    - unless: curl -s http://localhost:9200/_plugin/paramedic/index.html | grep Paramedic
    - require:
      - pkg: elasticsearch

/etc/pam.d/su:
  file:
    - sed
    - before: '# session    required   pam_limits.so'
    - after: 'session    required   pam_limits.so'

/etc/security/limits.conf:
  file:
    - append
    - text:
      - elasticsearch soft nofile 60000
      - elasticsearch hard nofile 60000
