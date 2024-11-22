# Yellow brick road
export PATH="$PATH:/opt/apache/maven/3.8.4/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# AWS SSO
alias aws_who='cat ~/.aws/config | grep profile'
alias aws_yeet='aws configure sso'
alias aws_stage='aws sso login --profile stage'
alias aws_prod='aws sso login --profile prod'

# EKS
alias eks_profile_example='aws eks --region us-west-2 update-kubeconfig --name conf-name --profile profile-name'
alias eks_namespace_example='kubectl config set-context --current --namespace=some-namespace'
alias cash_money="kubectl describe pod -n some-namespace $(kubectl get pods -n some-namespace | grep 'some-pod-name' | cut -d ' ' -f1)"

export HISTORY_IGNORE="(*PASSWORD*|*TOKEN*|*API_KEY*|*AWS_ACCESS_KEY_ID*|*AWS_SECRET_ACCESS_KEY*)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
