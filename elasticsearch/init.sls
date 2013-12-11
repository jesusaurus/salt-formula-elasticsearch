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
{% set confdir = salt['pillar.get']('elasticsearch:confdir', '/etc/elasticsearch') -%}
{% set datadir = salt['pillar.get']('elasticsearch:datadir', '/var/lib/elasticsearch') -%}
{% set logdir = salt['pillar.get']('elasticsearch:logdir', '/var/log/elasticsearch') -%}

elasticsearch_requirements:
  pkg.installed:
    - pkgs:
      - openjdk-7-jre-headless
      - curl

# we can't go outside for packages so this should be in an internal apt repo
# https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.deb
elasticsearch:
  pkg.installed:
    - require:
      - pkg: elasticsearch_requirements
  service:
    - running
    - require:
      - file: /etc/init.d/elasticsearch
      - file: {{ datadir }}
      - file: {{ logdir }}
      - file: /etc/default/elasticsearch
    - watch:
      - file: {{ confdir }}/default-mapping.json
      - file: {{ confdir }}/templates/logstash.json

/etc/init.d/elasticsearch:
  file.managed:
    - source: salt://elasticsearch/templates/elasticsearch.initd.jinja
    - template: jinja
    - mode: 755
    - require:
      - pkg: elasticsearch

{{ datadir }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - pkg: elasticsearch

{{ logdir }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - require:
      - pkg: elasticsearch

/etc/default/elasticsearch:
  file:
    - managed
    - source: salt://elasticsearch/templates/elasticsearch.default.jinja
    - template: jinja
    - require:
      - pkg: elasticsearch

{{ confdir }}/default-mapping.json:
  file:
    - managed
    - source: salt://elasticsearch/templates/default-mapping.json
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: elasticsearch

{{ confdir }}/templates/logstash.json:
  file:
    - managed
    - makedirs: true
    - source: salt://elasticsearch/templates/logstash-template.json
