# terraform
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FTrigpointingUK%2Fterraform.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FTrigpointingUK%2Fterraform?ref=badge_shield)


IaC repo for TrigpointingUK

Requires a file `operations/circleci_token` which contains an organization level Personal API Token for a CircleCI admin user
(eg [Ian Harris](https://app.circleci.com/settings/user/tokens?return-to=https%3A%2F%2Fapp.circleci.com%2Fprojects%2Fproject-dashboard%2Fgithub%2FTrigpointingUK-Teasel%2F)).

Requires a file for each Auth0 clientid (not secret, but neither should it be checked into git where it could be accidentally
reused by others). `tme_vue_auth0_clientid`, `tuk_vue_auth0_clientid`
