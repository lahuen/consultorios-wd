SOURCE_BRANCH ?= main
WEB_BRANCH ?= main
DOCKER_IMAGE ?= consultorios-app
PORT ?= 38090
DOCKER_REPO ?= lahuen/Consultorios

SOURCE_DIR := source_repo
WEB_DIR := web_repo

all: deploy

$(SOURCE_DIR):
	git clone -b $(SOURCE_BRANCH) https://github.com/lahuen/Consultorios.git $(SOURCE_DIR)

$(WEB_DIR):
	git clone -b $(WEB_BRANCH) https://github.com/lahuen/consultorios-wd.git $(WEB_DIR)

update-source:
	@if [ -d $(SOURCE_DIR) ]; then \
		cd $(SOURCE_DIR) && git fetch && git checkout $(SOURCE_BRANCH) && git pull; \
	else \
		$(MAKE) $(SOURCE_DIR); \
	fi

update-web:
	@if [ -d $(WEB_DIR) ]; then \
		cd $(WEB_DIR) && git fetch && git checkout $(WEB_BRANCH) && git pull; \
	else \
		$(MAKE) $(WEB_DIR); \
	fi

build-source: update-source
	cd $(SOURCE_DIR) && dotnet publish -c Release -o out

docker-build: build-source update-web
	cp -r $(SOURCE_DIR)/out/wwwroot/* $(WEB_DIR)/
	docker build -t $(DOCKER_IMAGE) $(WEB_DIR)

docker-push:
	docker tag $(DOCKER_IMAGE) $(DOCKER_REPO):$(SOURCE_BRANCH)
	docker push $(DOCKER_REPO):$(SOURCE_BRANCH)

docker-run:
	docker run -d -p $(PORT):38090 --name blazor-container $(DOCKER_IMAGE)

clean:
	-docker rm -f blazor-container || true
	-docker rmi $(DOCKER_IMAGE) || true
	rm -rf $(SOURCE_DIR) $(WEB_DIR)

deploy: docker-build docker-run
