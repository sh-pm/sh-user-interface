GROUP_ID=bash
ARTIFACT_ID=sh-user-interface
VERSION=v0.1.0

declare -A REPOSITORY=( \
	[host]="shpmcenter.com" \
	[port]=443 \
);

declare -A DEPENDENCIES=( \
    [sh-pm]=v3.3.0
    [sh-logger]=v1.4.0 \
    [sh-unit]=v1.5.4 \
	[sh-commons]=v2.2.2 \
);

SSO_API_AUTHENTICATION_URL=https://shpmcenter.com/sso/rest/api/sso/authentication
