#check jvm heap usage of Opensearch by promethues
curl -k -G "https://mypromethues.example.com/api/v1/query" --data-urlencode "query=opensearch_jvm_mem_heap_used_percent" | jq -r ".data.result[] | select(.metric.node == \"opensearch-cluster-master-0\" or .metric.node == \"opensearch-cluster-master-1\" or .metric.node == \"opensearch-cluster-master-2\") | \"\(.metric.node) : \(.value[1])\""
opensearch-cluster-master-0 : 53
opensearch-cluster-master-1 : 53
opensearch-cluster-master-2 : 53

##Selecters and Matchers
=
!= not equals (khong bao gom)
=~ (phu hop voi bat cu dieu gi bat dau bang /dev/sda ) {device=~"/dev/sda.*"}
!~

# get the data for the past two minutes
node_arp_entries{instance="node2"}[2m] offset 5m (ms, s, m h, d, w, y)
offset 1h30m

#backup to a specific point in time use
https://www.epochconerter.com

node_arp_entries{instance="node2"} @1663256188 # unix timestamp
node_arp_entries{instance="node2"} @1663256188 offset 5m
node_arp_entries{instance="node2"}[2m] @1663256188 offset 5m

#Operators
+ Addition
- Subtraction
* Multiplication
/ DIvision
% Module
^ Power

ex: node_memory_active_bytes{instance="node1", job="node"} /1024 .... # change result from bytes to Kilobytes

# Comparision operators
== Equal
!== not equal
> greater than
< less than
>=
<=

ex: node_network_flags > 100 # show result > 100

# return a true (1) or false (0)
node_filesystem_free_bytes < bool 1000 # >1000 will return 0 and < 1000 will return 1

# Binary operator precedence
1. ^
2. *,/,%,atan2 # 2 * 3 % 2 is equivalent to (2*3) % 2
3. +, -
4. ==, !=, <=, <, >=, >
5. and, unless
6. or

# Logical operatiors
OR 
AND 
UNLESS # tru khi

node_filesystem_free_bytes > 1000 unless node_filesystem_free_bytes > 300000

# Vertr matching

ignore
http_errors{code="500"} / ignoring(code) http_requests # or
http_errors{code="500"} / on(method) http_requests 

# Many - to - one
http_errors + on(path) group_left http_requests # right se khop voi nhieu trai
group_right  # left se khop voi nhieu phai

# Aggregation operators Toan tu tong hop
SUM 
min 
max 
avg 
group 
stddev 
stdvar 
count 
count_values 
bottomk 
topk 
quantile 

ex: sum by(path) (http_requests)
