# kube-news

## Repositório disponibilizado para o Desafio 2
Feito um fork de 

## Docker
```sh
docker build -t gustaff77/kube-news:v1 .
```
para rodar a aplicação use
Note que é preciso colocar as credenciais de um banco de dados postgres para funcionar
```sh
docker run --name k-news --rm -t -e DB_DATABASE="" -e DB_USERNAME="" -e DB_PASSWORD="" -e DB_HOST="" gustaff77/kube-news 
```

Caso precise de um banco use **DB_HOST="172.0.0.1"** (ou seu ip do docker) no comando acima e crie um container postgres com 
```sh
docker run -e POSTGRES_DB="" -e POSTGRES_USER="" -e POSTGRES_PASSWORD="" -e DB_HOST="127.0.0.1" postgres:15.0-alpine 
```

Por fim para subir em meu repositorio
```sh
docker push gustaff77/kube-news:v1
```
repetido para a tag latest


### K3D
Para criar o cluster
```sh
k3d cluster create meucluster -p "80:31000@loadbalancer"
```
Então para rodar neste cluster
```sh
kubectl apply -f deployment.yaml
```
Então acesse o browser na porta 80 (ou na que você colocou no comando de criação do cluster)

## Desafio 3
Reutilização do projeto para lançar um código com o terraform

Seguindo as boas práticas o arquivo inicial dele é o main.tf na pasta architeture
Foi utilizado o provedor Digital Ocean

### Na prática
Por estar em um único arquivo faça as duas partes
Antes de começar crie o arquivo `architeture/terraform.tfvars` e coloque as variáveis, confira quais são necessárias no final do arquivo `architeture/main.tf` também crie uma chave ssh e coloque o arquivo .pub dela em https://cloud.digitalocean.com/account/security

#### Cluster Kubernetes
Confira o arquivo terraform.example.tfvars e crie o terraform.tfvars a partir dele.
Entre no arquivo `deployment_cloud.yaml` e procure por {{TAG}} com as chaves duplas, troque por v1
Entre no diretório architeture e rode `terraform init`, ele instalará o provedor da digital ocean e o local_file. Confirá se está tudo certo com o `terraform plan -var-file=terraform.tfvars`.

Então rode `terraform apply -var-file=terraform.tfvars`.
Note o arquivo declarado na variável kub_config_file  e mova o para o arquivo de configuração do kubectl, provavelmente ~/.kube/config, assim quando rodar `kubectl get nodes` deverá aparecer nós do cluster recém criado.

Dessa forma você pode rodar o `kubectl apply -f deployment_cloud.yaml` na pasta raiz. E agora pegar o ip com `kubectl get Service` em LoadBalancer. Finalmente acesse pelo browser!! Provavelmente com o protocolo http sem o s.

#### Droplet jenkins
após rodar com `terraform apply -var-file=terraform.tfvars` pegue o jenkins_ip no final e use a chave ssh do par colocado na digital ocean com o usuário root para acessar a máquina do jenkins
`ssh -i <path-to-key> root@<ip>`

### Economize dinheiro
No final rode `terraform destroy` para limbar seu anbiente

## Desafio 4 - Jenkins

Usando a estrutura do desafio anterior, um cluster kubernetes e um droplet do digitalocean irei levantar com o `cd architeture` e então rodar o terraform (que esteja devidamente conectado, confira as variáveis no desafio 3 `terraform apply`

### Jenkins
No droplet foi instalado jenkins, docker e kubectl seguindo o site da ferramenta e para o jenkins ter acesso ao docker, foi adicionado o usuário dele ao grupo do docker com `usermod -aG docker jenkins` e restartado o jenkins

#### No Jenkins Setup
Instalado os Plugins sugeridos, git, git pipeline e kubectl cli

Foi criado uma pipeline simples que lê o Jenkinsfile deste repositório.

Para a pipeline funcionar corretamente deve existir o {{TAG}} na imagem docker dos pods no arquivo deployment_cloud.yaml

#### Aprendizados

Foram usados dois tipos de credeciais, arquivo e usuário e senha com uma api de docker no groovy pipeline e kubectl

Uso de webhooks através do git hub

## Desafio 5

O arquivo prometheus_grafana_manifest.yaml foi instalado por https://gist.githubusercontent.com/fabricioveronez/a9bceb94065d4689dcadd6c2a09d7322/raw/95ae9c66b0bfeaef0837e0042482c6579717e06c/deploy-prometheus-grafana.yaml

Considerando que a arquitetura está após o estado do desafio 4, rode
```kubectl --kubeconfig=architeture/kube_config.yaml apply -f prometheus_grafana_manifest.yaml```
assim temos nossa arquitetura

Para isso foi adicionado no `deployment_cloud.yaml` as configurações do prometheus nos pods através de annotations