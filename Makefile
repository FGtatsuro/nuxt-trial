.PHONY: clean
.PHONY: docker/build docker/rebuild
.PHONY: nuxt/dev nuxt/build nuxt/start nuxt/stop

IMAGE := nuxt-trial
CONTAINER := nuxt-trial-container

clean: nuxt/stop
	rm -f .docker_build
	rm -rf .nuxt node_modules

docker/build: .docker_build
.docker_build: package.json package-lock.json
	docker build -t $(IMAGE):latest .
	touch .docker_build

docker/rebuild: clean docker/build

# NOTE: Use anonymous volume to avoid overwriting node_modules.
#   FYI: https://docs.docker.com/storage/volumes/#populate-a-volume-using-a-container
# NOTE: Current latest node causes OpenSSL related error.
#   FYI: https://github.com/webpack/webpack/issues/14532
nuxt/dev: docker/build
	if [ -z "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker run \
			--name $(CONTAINER) \
			-d -it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-p 3000:3000 \
			-e HOST=0.0.0.0 \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			nuxt; \
	fi

nuxt/build: docker/build
	docker run \
		-it --rm \
		-v `pwd`:/workdir -v /workdir/node_modules \
		-e NODE_OPTIONS=--openssl-legacy-provider \
		$(IMAGE):latest \
		nuxt build;

nuxt/start: docker/build
	if [ -z "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker run \
			--name $(CONTAINER) \
			-d -it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-p 3000:3000 \
			-e HOST=0.0.0.0 \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			nuxt start; \
	fi

nuxt/stop:
	if [ -n "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker rm -f $(CONTAINER); \
	fi
