elasticsearch:
  confdir: /etc/elasticsearch
  datadir: /var/lib/elasticsearch
  logdir: /var/log/elasticsearch
# use eth1, as under vagrant private network or public network, eth1 is the useful interface
  interface: eth1
  cluster_name: randomname
  es_heap_size: 1024
  indexsize: 20%
  publish:
    es01: 127.0.10.1
    es02: 127.0.10.2
  zone:
    es01: az1
    es02: az2
