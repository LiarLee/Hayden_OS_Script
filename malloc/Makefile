deploy: 
	aws ecr get-login-password --region cn-north-1 | docker login --username AWS --password-stdin 177679732782.dkr.ecr.cn-north-1.amazonaws.com.cn/haydenarchlinux
	docker push 177679732782.dkr.ecr.cn-north-1.amazonaws.com.cn/hayden-malloc:2024-05-30 
	docker push 177679732782.dkr.ecr.cn-north-1.amazonaws.com.cn/hayden-malloc:latest

build:
	dive build -t 177679732782.dkr.ecr.cn-north-1.amazonaws.com.cn/hayden-malloc:2024-05-30 -t 177679732782.dkr.ecr.cn-north-1.amazonaws.com.cn/hayden-malloc:latest ./

