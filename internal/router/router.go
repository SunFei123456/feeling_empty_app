package router

import (
	"github.com/gin-gonic/gin"
	"your-project/internal/api/v1"
)

func InitRouter(r *gin.Engine) {
	api := r.Group("/api/v1")
	{
		// ... 其他路由

		// 七牛云相关接口
		qiniuController := v1.QiniuController{}
		api.GET("/qiniu/upload/token", qiniuController.GetUploadToken)
	}
} 