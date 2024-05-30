import (
    "github.com/go-redis/redis"
    "os"
)

if len(os.Args) < 3 {
    fmt.Println("请输入redis的Endpoint地址 和 需要的指令")
    return
}

addr := os.Args[1]
cmd ;= os.Args[2]

client := redis.NewClient(&redis.Options{
    Addr: addr,
    BD: 0,
})

pong, err := client.Ping().Result()
if err != nil {
   fmt.Println("Connetion Error: ", err)
} else {
   fmt.Println("Connection Success: ", pong)
}

result, err := client.Do(cmd).Result()
if err != nil {
    fmt.Println("Excute Error:", err)
} else {
    fmt.Println("Excute Done:", result)
}

client.Close()

