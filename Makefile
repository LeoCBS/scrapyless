version?=latest
image?=leocbs/scrapyless:$(version)

build-image:
	docker build . -f Dockerfile -t $(image)

push-image: build-image
	docker push $(image)