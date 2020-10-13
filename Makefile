repository = xcometh/game
file = game.js

.PHONY: create_release list_releases_ids remove_release list_references delete_reference

create_release:
ifndef tag
		echo "\e[1;31m	(!) To create a release, you need to pass a \"tag\" arg.\e[0m"
		exit 1
endif

	$(eval hash=$(shell sha256sum lib/app.js | awk '{ print $$1 }'))
	$(eval body=$(shell echo "$(file) (sha256): $(hash)"))

	$(eval upload_url=$(shell curl -s -X POST -H "Accept: application/vnd.github.v3+json" \
		--header "Authorization: token ${GITHUB_AUTHORIZATION_TOKEN}" \
		https://api.github.com/repos/$(repository)/releases \
		-d '{"tag_name":"$(tag)","body":"$(body)"}' | jq '.upload_url'))

	$(eval upload_url=$(shell echo "$(upload_url)" | sed 's/{?name,label}//g'))

	curl -s -X POST -H "Accept: application/vnd.github.v3+json" \
		--header "Authorization: token ${GITHUB_AUTHORIZATION_TOKEN}" \
		--header "Content-Type: application/octet-stream" \
		$(upload_url)?name=$(file) --data-binary @"lib/app.js" > /dev/null

list_releases_ids:
	curl -s -H "Accept: application/vnd.github.v3+json" \
		--header "Authorization: token ${GITHUB_AUTHORIZATION_TOKEN}" \
		https://api.github.com/repos/$(repository)/releases | jq '.[].id'

remove_release:
ifndef id
		echo "\e[1;31m	(!) To remove a release, you need to pass an \"id\" arg.\e[0m"
		exit 1
endif

	curl -s -X DELETE -H "Accept: application/vnd.github.v3+json" \
		--header "Authorization: token ${GITHUB_AUTHORIZATION_TOKEN}" \
		https://api.github.com/repos/$(repository)/releases/$(id)

list_references:
	curl -s -H "Accept: application/vnd.github.v3+json" \
		--header "Authorization: token ${GITHUB_AUTHORIZATION_TOKEN}" \
		https://api.github.com/repos/$(repository)/git/matching-refs/tags | jq '.[].ref'

delete_reference:
ifndef ref
		echo "\e[1;31m	(!) To delete a reference, you need to pass a \"ref\" arg.\e[0m"
		exit 1
endif

	curl -s -X DELETE -H "Accept: application/vnd.github.v3+json" \
		--header "Authorization: token ${GITHUB_AUTHORIZATION_TOKEN}" \
		https://api.github.com/repos/$(repository)/git/$(ref)
