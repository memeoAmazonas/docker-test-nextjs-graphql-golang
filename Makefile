url_base = https://github.com/memeoAmazonas/
front_name=test-nextjs-golang-graphql-new-front-2022
back_name=test-nextjs-golang-graphql-back-server-2022
client_name=test-nextjs-golang-graphql-back-client-2022
BUILDPATH=$(CURDIR)

delete-repo:
	-rm -rf $(front_name)
	-rm -rf $(back_name)
	-rm -rf $(client_name)

get-repos:
	git clone $(url_base)$(front_name) && git clone $(url_base)$(back_name) && git clone $(url_base)$(client_name)

pull-repos:
	cd ./${front_name} && git pull origin main && cd .. && cd ./${back_name} && git pull origin main && cd .. &&  cd ./${client_name} && git pull origin main

clone: delete-repo get-repos pull-repos

compose:
	docker-compose -f docker-compose.yml up --build -d

docker: clone compose

stop:
	docker-compose -f docker-compose.yml stop

mongo-db:
	@echo "mongo..."
	cd $(BUILDPATH)/mongo && docker-compose -f docker-compose.yml up --build -d

dev-client:
	cd $(BUILDPATH)/$(client_name) && go mod download && go run cmd/main.go

dev-server:
	cd $(BUILDPATH)/$(back_name) && go mod download && go run cmd/server.go

dev-front:
	cd $(BUILDPATH)/$(front_name) && yarn install && npm run dev

dev:
	make -j 4 stop mongo-db dev-server dev-client dev-front

#	@go build -o $(BUILDPATH)/build/bin/${BINARY} cmd/server.go

