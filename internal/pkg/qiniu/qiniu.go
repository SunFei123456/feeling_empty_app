package qiniu

import (
    "fmt"
    "time"
    "github.com/qiniu/go-sdk/v7/auth/qbox"
    "github.com/qiniu/go-sdk/v7/storage"
)

type Config struct {
    AccessKey     string
    SecretKey     string
    BucketName    string
    BucketDomain  string
}

var defaultConfig *Config

// 初始化七牛云配置
func InitQiniu(cfg *Config) {
    defaultConfig = cfg
}

// 获取上传凭证
func GetUploadToken(key string) (string, error) {
    if defaultConfig == nil {
        return "", fmt.Errorf("qiniu config not initialized")
    }

    mac := qbox.NewMac(defaultConfig.AccessKey, defaultConfig.SecretKey)
    
    putPolicy := storage.PutPolicy{
        Scope:      fmt.Sprintf("%s:%s", defaultConfig.BucketName, key),
        ReturnBody: `{"key":"$(key)","hash":"$(etag)","size":$(fsize),"name":"$(fname)"}`,
        Expires:    3600, // 1小时有效期
    }

    return putPolicy.UploadToken(mac), nil
}

// 生成资源的完整URL
func GetResourceURL(key string) string {
    return fmt.Sprintf("https://%s/%s", defaultConfig.BucketDomain, key)
} 