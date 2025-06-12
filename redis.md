https://viblo.asia/p/redis-co-ban-57rVRq5OR4bP

| Command | content |
| ---- | ------- |
| DEL key	| Xóa key nếu nó tồn tại |
| EXISTS key	| Kiểm tra key có tồn tại không |
| EXPIRE key n |	Đặt expire time cho key sau n giây |
| KEYS pattern |	Tìm các key theo pattern |
| PERSIST key |	Xóa expire time của key |
| TTL key	| Lấy thời gian sống của key (giây) |
| RENAME key newkey	| Đổi tên key sang newkey, nếu newkey đã tồn tại giá trị của nó sẽ bị ghi đè bởi giá trị của key |
| RENAMENX key newkey	| Đổi tên key sang newkey nếu newkey chưa tồn tại |
| TYPE key	| Lấy loại dữ liệu được lưu trữ bởi key |

Redis String
SET test redis
OK
GET test
"redis"
| Command | content |
| ---- | ------- |
| SET key value	| Đặt giá trị value cho key |
| GET key		| Lấy giá trị lưu trữ bởi key |
| GETRANGE key start end	| Lấy giá trị lưu trữ bởi key từ (start) đến (end)|
| GETSET key value	| Lấy ra giá trị cũ và đặt giá trị mới cho keY            |
| MGET key1 key2 ..	| Lấy giá trị của nhiều key theo thứ tự                   |
| SETEX key seconds value	| Đặt giá trị và thời gian expire cho key         |
| SETNX key value	| Đặt giá trị cho key nếu key chưa tồn tại                |
| RENAMENX key newkey	| Đổi tên key sang newkey nếu newkey chưa tồn tại     |
| STRLEN key	| Lấy độ dài giá trị lưu trữ bởi key                          |
| APPEND key value	| Thêm vào sau giá trị lưu trữ bởi key là value           |
| INCR key	| Tăng giá trị lưu trữ của key (số nguyên) 1 đơn vị               |
| INCRBY key n	| Tăng giá trị lưu trữ của key (số nguyên) n đơn vị           |
| DECR key	| Giảm giá trị lưu trữ của key (số nguyên) 1 đơn vị               |
| DECRBY key n	| Giảm giá trị lưu trữ của key (số nguyên) n đơn vị           |

Redis Hash

HSET user:1 name "name 1"
(integer) 1
HGET user:1 name
"name 1"

| Command | content |
| ---- | ------- |
| HSET key field value	| Đặt giá trị cho field là value trong hash                                             | 
| HGET key field		| Lấy giá trị của field trong hash                                                          | 
| HDEL key field1 field2 ... | 	xóa field1, field2 ... trong hash                                             | 
| HEXISTS key field	| Kiểm tra file có tồn tại trong hash không                                                 | 
| HGETALL key	| Lấy tất cả các field và value của nó trong hash                                               | 
| HINCRBY key field n |	Tăng giá trị của field (số nguyên) lên n đơn vị                                       | 
| HDECRBY key field n |	Giảm giá trị của field (số nguyên) lên n đơn vị                                       | 
| HINCRBYFLOAT key field f |	Tăng giá trị của field (số thực) lên f                                            | 
| HDECRBYFLOAT key field n |	Giảm giá trị của field (số thực) f                                                | 
| HKEYS key	| Lấy tất cả các field của hash                                                                     | 
| HVALS key	| Lấy tất cả các value của hash                                                                     | 
| HLEN key	| Lấy số lượng field của hash                                                                       | 
| HMSET key field1 value1 field2 value2 ...	| Đặt giá trị cho các field1 giá trị value1 field2 giá trị value2 ..| 
| HMGET key field1 field2 ...	| Lấy giá trị của các field1 field2 ... |


