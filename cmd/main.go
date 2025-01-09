package main

import (
	"os"
	"your-project/internal/pkg/qiniu"
)

func main() {
	// ... 其他初始化代码

	// 初始化七牛云配置
	qiniu.InitQiniu(&qiniu.Config{
		AccessKey:    os.Getenv("QINIU_ACCESS_KEY"),
		SecretKey:    os.Getenv("QINIU_SECRET_KEY"),
		BucketName:   os.Getenv("QINIU_BUCKET_NAME"),
		BucketDomain: os.Getenv("QINIU_BUCKET_DOMAIN"),
	})

	// ... 启动服务器
} 