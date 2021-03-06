.PHONY: clean
.PHONY: docker/build docker/rebuild
.PHONY: dev build start stop logs lint fix

IMAGE := nuxt-trial
CONTAINER := nuxt-trial-container

clean: stop
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
dev: docker/build
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

build: docker/build
	if [ -z "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker run \
			-it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			nuxt build; \
	else \
		docker exec \
			-it \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(CONTAINER) \
			npx nuxt build; \
	fi

start: docker/build
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

stop:
	if [ -n "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker rm -f $(CONTAINER); \
	fi

logs:
	if [ -n "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker logs -f $(CONTAINER) || exit 0;\
	fi

lint:
	if [ -z "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker run \
			-it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			eslint --ext .ts,.js,.vue --ignore-path .gitignore --ignore-pattern .eslintrc.js . && \
		docker run \
			-it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			stylelint **/*.vue --ignore-path .gitignore; \
	else \
		docker exec \
			-it \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(CONTAINER) \
			npx eslint --ext .ts,.js,.vue --ignore-path .gitignore --ignore-pattern .eslintrc.js . && \
		docker exec \
			-it \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(CONTAINER) \
			npx stylelint **/*.vue --ignore-path .gitignore; \
	fi

fix:
	if [ -z "`docker ps -a | grep $(CONTAINER)`" ]; then \
		docker run \
			-it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			eslint --ext .ts,.js,.vue --ignore-path .gitignore --ignore-pattern .eslintrc.js --fix . && \
		docker run \
			-it --rm \
			-v `pwd`:/workdir -v /workdir/node_modules \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(IMAGE):latest \
			stylelint **/*.vue --ignore-path .gitignore --fix; \
	else \
		docker exec \
			-it \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(CONTAINER) \
			npx eslint --ext .ts,.js,.vue --ignore-path .gitignore --ignore-pattern .eslintrc.js --fix . && \
		docker exec \
			-it \
			-e NODE_OPTIONS=--openssl-legacy-provider \
			$(CONTAINER) \
			npx stylelint **/*.vue --ignore-path .gitignore --fix; \
	fi
